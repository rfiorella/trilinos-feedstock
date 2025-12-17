mkdir -p build
cd build

export CMAKE_GENERATOR="Ninja"

if [[ "${target_platform}" == osx-* ]]; then
    export CXXFLAGS="${CXXFLAGS} -stdlib=libc++ -D_LIBCPP_DISABLE_AVAILABILITY"
fi

export MPI_FLAGS="--allow-run-as-root"

if [ $(uname) == Linux ]; then
    export MPI_FLAGS="$MPI_FLAGS;-mca;plm;isolated"
fi


cmake -G Ninja \
  -D CMAKE_BUILD_TYPE:STRING=RELEASE \
  -D CMAKE_INSTALL_PREFIX:PATH=$PREFIX \
  -D CMAKE_PREFIX_PATH:PATH=$PREFIX \
  -D BUILD_SHARED_LIBS:BOOL=ON \
  -D TPL_ENABLE_MPI:BOOL=ON \
  -D TPL_ENABLE_UMFPACK:BOOL=ON \
  -D TPL_ENABLE_HDF5:BOOL=ON \
  -D TPL_ENABLE_Kokkos:BOOL=ON \
  -D TPL_ENABLE_KokkosKernels:BOOL=ON \
  -D Kokkos_DIR:PATH="${PREFIX}/lib/cmake/Kokkos" \
  -D KokkosKernels_DIR:PATH="${PREFIX}/lib/cmake/KokkosKernels" \
  -D UMFPACK_LIBRARY_DIRS:PATH="${PREFIX}/lib/suitesparse" \
  -D UMFPACK_INCLUDE_DIRS:PATH="${PREFIX}/include/suitesparse" \
  -D MPI_BASE_DIR:PATH=$PREFIX \
  -D MPI_EXEC:FILEPATH=$PREFIX/bin/mpiexec \
  -D PYTHON_EXECUTABLE:FILEPATH=$PYTHON \
  -D CMAKE_C_FLAGS="-Wno-implicit-function-declaration" \
  -D Trilinos_ENABLE_OpenMP:BOOL=ON \
  -D Trilinos_ENABLE_Fortran:BOOL=ON \
  -D Trilinos_ENABLE_ALL_PACKAGES:BOOL=ON \
  -D Trilinos_ENABLE_ALL_OPTIONAL_PACKAGES:BOOL=ON \
  -D Trilinos_ENABLE_SEACAS:BOOL=ON \
  -D Ifpack2_ENABLE_TESTS:BOOL=OFF \
  -D NOX_ENABLE_LOCA:BOOL=ON \
  -D Teuchos_ENABLE_COMPLEX:BOOL=ON \
  -D Trilinos_ENABLE_COMPLEX_DOUBLE:BOOL=ON \
  -D Trilinos_ENABLE_PyTrilinos:BOOL=ON \
  -D Teuchos_ENABLE_PYTHON=ON \
  -D Trilinos_ENABLE_DEPRECATED_CODE_WARNINGS:BOOL=OFF \
  -D PyTrilinos_ENABLE_Teuchos=ON \
  -D PyTrilinos_ENABLE_Tpetra=ON \
  -D PyTrilinos_ENABLE_Epetra=ON \
  -D PyTrilinos_ENABLE_NOX=ON \
  $SRC_DIR

ninja -j $CPU_COUNT
ninja install

