#ifndef _H_CritSect
#define _H_CritSect

#include "Common.h"

class CritSync;

namespace Sexy
{

class CritSect 
{
private:
        CRITICAL_SECTION mCriticalSection;
        friend class AutoCrit;

public:
        CritSect(void);
        ~CritSect(void);
};

class AutoCrit
{
private:
        CritSect& mCritSect;

public:
        AutoCrit(CritSect& theCritSect) : mCritSect(theCritSect)
        {
                EnterCriticalSection(&mCritSect.mCriticalSection);
        }

        ~AutoCrit()
        {
                LeaveCriticalSection(&mCritSect.mCriticalSection);
        }
};

}

#endif // _H_CritSect
