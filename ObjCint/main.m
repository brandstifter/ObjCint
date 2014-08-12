//
//  main.m
//  ObjCint
//
//  Created by Thomas Brandstätter on 09/02/14.
//  Copyright (c) 2014 Thomas Brandstätter. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "unistd.h"
#import "stdio.h"

#import "System.h"
#import "FrameworkLoader.h"

#import <M2Debug/M2Debug.h>

#import "y.tab.h"




typedef NS_ENUM(NSInteger, TBCCVerboseMode) {

    TBCCVerboseMode_none        = 1,
    TBCCVerboseMode_1           = 1 << 1,
    TBCCVerboseMode_2           = 1 << 2 | TBCCVerboseMode_1,
    TBCCVerboseMode_3           = 1 << 3 | TBCCVerboseMode_2
};

typedef NS_ENUM(NSInteger, TBCCWarningMode) {

    TBCCWarningMode_none        = 1,
    TBCCWarningMode_ignImport   = 1 << 1,
    TBCCWarningMode_ignStdin    = 1 << 2,
    TBCCWarningMode_All         = 0
};

#define DLog(level, fmt, ...) do {                                  \
        if (level == 2 && verboseMode & TBCCVerboseMode_2)          \
            (void)fprintf(  stdout,                                 \
                            "[D%d] %s:%3d [%s]: " fmt "\n",         \
                            level,                                  \
                            __FILE_ONLY__, __LINE__,                \
                            __FUNCTION__, ##__VA_ARGS__);           \
    } while (0)



/**
 If you are writing a header file that must work when included in ISO C
 programs, write __typeof__ instead of typeof.

 @see http://stackoverflow.com/questions/3437404/min-and-max-in-c
 */
#define max(a,b) \
    ({  __typeof__ (a) _a = (a); \
        __typeof__ (b) _b = (b); \
        _a > _b ? _a : _b; })


extern void yyrestart( FILE *);
extern int yyparse ();
extern FILE *yyin;

extern TBCCBlock *rootBlock;
extern int yyErrorCode;


#pragma mark - flags
/** @{ group flags */
static BOOL continueAfterEOF    = YES;                          /**< flag q */
static BOOL cleanupAfterFile    = NO;                           /**< flag C */
    //static BOOL showDeclarations    = NO;                     /**< flag D */

static TBCCVerboseMode verboseMode = TBCCVerboseMode_none;      /**< flag v */
static TBCCWarningMode warningMode = TBCCWarningMode_All;       /**< flag W */

/** @} */

static int moreArgs             = 0;    /**< total non getopt args       */
static int fileArgs             = 0;    /**< total file args             */
static int envArgs              = 0;    /**< total environment args      */
static int sepArg               = 0;    /**< the position of the '-' if any */

static int inputFiles           = 0;    /**< total input files */

static char *progname           = NULL; /**< reference to argv[0] */
static char *progcwd            = NULL; /**< current working directory */


#pragma mark - private functions declaration
/** @{ group private functions declaration */


static void cleanup(void);              /**< release memory */
static int cleanup_file(FILE *file);
static void usage(void);                /**< prints usage and exit */
static void help(void);

/**
 run interpreter

 @param file    The file pointer to assign to yyin
 */
static void process_file(FILE *file);
/** @} */



#pragma mark - Entry Point

/**
 The Entry Point
 
 @return program execution result
    0   ... all went well
    1   ... lexical error
    2   ... semantic error
    3   ... runtime errors
 */
int main(int argc, char *argv[])
{
    int ch              = 0;                /* getopt current option */

    int C_option_occur  = 0;                /* number of C option occurences */
    int d_option_occur  = 0;                /* number of d option occurences */
    int D_option_occur  = 0;                /* number of D option occurences */
    int h_option_occur  = 0;                /* number of h option occurences */
    int r_option_occur  = 0;                /* number of r option occurences */
    int v_option_occur  = 0;                /* number of v option occurences */
    int W_option_occur  = 0;                /* number of W option occurences */

    progname = argv[0];
    progcwd  = getcwd(progcwd, 0);

    warningMode = TBCCWarningMode_All;

    if (progcwd == NULL) {
        (void)fprintf(stderr, "[E] cannot aquire getcwd: %s", strerror(errno));
        exit(1);
    }

    while ((ch = getopt(argc, argv, "vWd")) != -1) {
        switch (ch) {
            case 'v':
                v_option_occur++;
                if (v_option_occur > 3)
                    usage();

                verboseMode &= (verboseMode << 1);
                break;

            case 'W':
                W_option_occur++;

                if (strncmp(optarg, "n", strlen("n")))
                    warningMode = TBCCWarningMode_none;
                else if (strncmp(optarg, "ii", strlen("ii")))
                    warningMode = TBCCWarningMode_ignImport;
                else if (strncmp(optarg, "isi", strlen("ii")))
                    warningMode = TBCCWarningMode_ignImport;
                else if (strncmp(optarg, "a", strlen("a")))
                    warningMode = TBCCWarningMode_All;

                break;
            case 'd':
                d_option_occur++;
                if (d_option_occur > 1)
                    usage();

                [[M2Logger sharedInstance] setDebugLevelMask:M2DebugLevelAllMask];

                if (verboseMode & TBCCVerboseMode_1)
                    (void)printf("[D2]: debugMode On: %s", optarg);
                
                break;

            case ':':
                usage();
                break;

            case '?':       /* fall through */

            default:
                break;
        }
    }

    optind = 1;
    while ((ch = getopt(argc, argv, "CdDhrvW")) != -1) {

        switch (ch) {
            case 'C':
                C_option_occur++;
                if (C_option_occur > 1)
                    usage();

                cleanupAfterFile = YES;

                if (verboseMode & TBCCVerboseMode_2)
                    (void)printf("[D2]: verboseMode On: %s", optarg);

                break;

            case 'D':
                D_option_occur++;
                if (D_option_occur > 1)
                    usage();

                System *system = [System sharedInstance];
                [system addDefinition:[NSString stringWithUTF8String:optarg]];

                DLog(2, "add definition: %s", optarg);

                break;

            case 'r':
                r_option_occur++;
                if (r_option_occur > 1)
                    usage();


                break;

            case 'h':
                h_option_occur++;
                if (h_option_occur > 1)
                    usage();

                help();

            case 'W':   /* fall through */
            case 'd':
            case 'v':
                /* ignore */
                break;



            case ':':   /* fall through */
            case '?':
                NSLog(@"illegal argument");
//                usage();

                NSLog(@"%c %c", ch, optopt);

                break;

            default:
                break;

        }
    }


        // load frameworks

	@autoreleasepool {
		
		FrameworkLoader *loader = [FrameworkLoader sharedInstance];
		loader.currentVersion = @"101";
		[loader loadCurrentTR064Framework];
		
		loader.currentVersion = @"99";
		[loader loadCurrentTR064Framework];
		
        //  non getopt arguments
		moreArgs    = argc - optind;
		fileArgs    = optind + 1;
		envArgs     = optind + 1;
		sepArg      = optind;
		
		int aii     = optind;
		for (; aii < argc; aii++) {
			if ( strncmp(argv[aii], "-", strlen("-")) ) {
				sepArg = aii;
				envArgs = sepArg +1;
				break;
			}
		}
		
		
		while (fileArgs < sepArg) {
			
			System *sys = [System sharedInstance];
			FILE *file = fopen(argv[fileArgs], "r");
			
			if (file == NULL) {
				sys.filename = nil;
				(void)fprintf(stderr, "cannot open '%s' for reading: %s ", argv[fileArgs], strerror(errno));
			}
			else {
				sys.filename = [NSString stringWithUTF8String:argv[aii]];
				process_file(file);
				cleanup_file(file);
			}
			
			if (cleanupAfterFile) {}
			
			fileArgs++;
		}
		
		
		//	volatile BOOL continueParsing = YES;
		//	while (continueParsing)
		
		process_file(stdin);
		cleanup();
		
	}

    return 0;
}


#pragma mark - private functions

static void process_file(FILE *file) {

    if (file == NULL) {
        (void)fprintf (stderr, "file NULL\n");
        return;
    }
	
	yyrestart( file );
	
	/*
	 we stop parsing by throw an error via the yyerror(char *) function.
	 yyparse returns 0 on success or 1 on *any* error occured. therefore
	 we need the yyErrorCode variable to distinguish different errors.
	 */
	int rc = yyparse();
	if (rc == 0) {
		[rootBlock codegen];
	}
	
	
//        TBCCInputTracer *inputTrace = [TBCCInputTracer sharedInstance];
//
//        if (warningMode == TBCCWarningMode_All) {
//            for (NSObject *line in inputTrace.warnings)
//                NSLog(@"W %@ \n", line.description);
//        }
//
//        if (showDeclarations) {
//            System *proxy = [System sharedInstance];
//
//            NSLog(@"declarations:");
//            for (NSString *declarationKey in proxy.declarations) {
//                NSLog(@"    %@\n", [proxy.declarations objectForKey:declarationKey]);
//            }
//
//            NSLog(@"variables:");
//            for (NSString *variableKey in proxy.variables) {
//                NSLog(@"    %@ = %@\n", variableKey, [proxy.variables objectForKey:variableKey]);
//            }
//
//        }
//
//        for (NSObject *line in inputTrace.errors)
//            NSLog(@"E %@ \n", line.description);
	
}





static void cleanup(void) {

    if (progcwd != NULL) {
        free(progcwd);
        progcwd = NULL;
    }
}

static int cleanup_file(FILE *file) {

    if (!file)
        return 0;

    int rc = fclose(file);

    if (rc == 0)
        (void)fprintf(stderr, "error: %s ", strerror(errno));

    return rc;
}



static void usage(void) {

    (void)fprintf(stderr, "Synopsis: \n\t%s [-[v|vv|vvv]] [-W mode] [-CdDr] [[files ...] [- [sys_args ...]]\n", progname);
    exit(1);
}

static void help(void) {
    (void)fprintf(stderr, "Help:\n");

}
