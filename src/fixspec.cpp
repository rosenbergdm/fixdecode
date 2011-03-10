//
//  fixspec.cpp - trace the fix fields for a given msg type
//
//      USAGE fixspec <msgtype>
//
//
#include <stdlib.h>
#include <cstring>
#include <cassert>
#include <vector>
#include <map>
#include <string>
#include <sstream>
#include <fstream>
#include <iostream>

#include <libxml/parser.h>
#include "fixcore.h"


int main(int argc, char *argv[]) 
{
    // handle args


    const char* szspecfile = "./spec/FIX44.xml";

    if (argc<2)
    {
        fprintf(stdout, "USAGE: fixspec <msgtype>\n");
        fprintf(stdout, "  option -E                    : show field allowed enum values\n");
        fprintf(stdout, "  option -S=<FIXspec.xml>      : use spec file FIXspec.xml\n");
        exit(-1);
    }

    const char* sztype = argv[1];

    mapss options;
    for (int i=2;i<argc;i++)
    {
        const char* szopt=argv[i];

        if (0==strcmp(szopt,"-E"))
            options["enums"]="Y";

        if (0==strncmp(szopt, "-S", 2))
        {
            if (strlen(szopt)>3)
                szspecfile = szopt+3;
            else
                fprintf(stdout,"Bad option -S\n"), exit(-1);
        }
    }

    fprintf(stdout,"Using spec : %s\n", szspecfile);

    // parse the spec, expand the components, show the spec for the message type

    XNode* ndfix = parse_fix_spec_xml(szspecfile); 
    if (!ndfix)
        exit(-1);

    MessageGenerator fixgen(ndfix);
    fixgen.show_expanded_spec(sztype, options);

    // cleanup

    delete ndfix;
}

