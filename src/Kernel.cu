#include "Kernel.h"

__global__
void cukernel(Real* in, Real* out, const int kSize, const int iStride, const int jStride, const int kStride)
{

    int ipos = blockIdx.x * 32 + threadIdx.x;
    int jpos = blockIdx.y * 8 + threadIdx.y;

    for(int k=0; k < kSize; ++k)
    {
        out[ipos*iStride + jpos*jStride + k*kStride] = in[ipos*iStride + jpos*jStride + k*kStride];
    }

}

void launch_kernel(IJKSize domain, Real* in, Real* out)
{
    dim3 threads, blocks;
    threads.x = 32;
    threads.y = 8;
    threads.z = 1;

    blocks.x = domain.iSize() / 32;
    blocks.y = domain.jSize() / 8;
    blocks.z = 1;
    if(domain.iSize() % 32 != 0 || domain.jSize() % 8 != 0)
        std::cout << "ERROR: Domain sizes should be multiple of 32x8" << std::endl;

    const int iStride = 1;
    const int jStride = domain.iSize()+cNumBoundaryLines*2;
    const int kStride = (domain.jSize()+cNumBoundaryLines*2)* jStride;
    cukernel<<<blocks, threads>>>(in, out, iStride, jStride, kStride);
}
