#ifndef __MEMORYOUTPUTMODULE_H__
#define __MEMORYOUTPUTMODULE_H__

#include "Buffer.h"
#include "Common.h"

namespace Sexy
{

// MemoryOutput structure for audio output to memory
struct MemoryOutput
{
    int mBitsPerSample;
    int mNumChannels;
    int mSamplingRate;
    ByteVector mByteVector;
};

}

#endif // __MEMORYOUTPUTMODULE_H__
