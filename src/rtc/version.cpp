//-------------------------------------------------------------------------------------------------
//function:     for run-time check about version number
//-------------------------------------------------------------------------------------------------

#include "pch.h"

namespace brb 
{
    Version versionCheck()
    {
        Version version;
        version.major = BRB2_MAJOR_VERSION;
        version.minor = BRB2_MINOR_VERSION;
        version.patch = BRB2_PATCH_VERSION;
        return version;
    }
}