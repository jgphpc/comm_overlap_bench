#!/usr/bin/env bash
rm -rf build_cuda75
mkdir -p build_cuda75

module purge
module load CMake
source modules_kesch_cuda75.env
module load Score-P/3.0-gmvapich2-17.02_cuda_7.5_gdr
module list -t
echo

export SCOREP_ROOT=$EBROOTSCOREMINP
export SCOREP_WRAPPER_ARGS="--mpp=mpi --cuda --keep-files --verbose" 
export CC=`which scorep-gcc`
export CXX=`which scorep-g++`
export NVCC=`which scorep-nvcc`
export BOOST_ROOT="/apps/escha/UES/RH6.7/easybuild/software/Boost/1.63.0-gmvapich2-17.02_cuda_7.5_gdr-Python-2.7.12"

export SRC_DIR=$(pwd)

pushd build_cuda75 &>/dev/null
SCOREP_WRAPPER=OFF cmake .. \
    -DCMAKE_CXX_FLAGS="-std=c++11" \
    -DMPI_VENDOR=mvapich2 \
    -DENABLE_TIMER=OFF \
    -DCUDA_COMPUTE_CAPABILITY="sm_37" \
    -DCMAKE_BUILD_TYPE=Debug \
    -DBOOST_ROOT="${BOOST_ROOT}" \
    -DCMAKE_CXX_COMPILER="${CXX}" \
    -DCMAKE_C_COMPILER="${CC}" \
    -DCUDA_NVCC_EXECUTABLE="${NVCC}" \
    -DCUDA_HOST_COMPILER=`which g++`

    
    export SCOREP_WRAPPER=ON
    make -j 8 \
        SCOREP_WRAPPER_INSTRUMENTER_FLAGS="--cuda --mpp=mpi --verbose --keep-files" 
#        VERBOSE=1        

