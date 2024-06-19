{-# LANGUAGE CPP #-}
{-# LANGUAGE NoRebindableSyntax #-}
#if __GLASGOW_HASKELL__ >= 810
{-# OPTIONS_GHC -Wno-prepositive-qualified-module #-}
#endif
{-# OPTIONS_GHC -fno-warn-missing-import-lists #-}
{-# OPTIONS_GHC -w #-}
module Paths_nombre_test (
    version,
    getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where


import qualified Control.Exception as Exception
import qualified Data.List as List
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude


#if defined(VERSION_base)

#if MIN_VERSION_base(4,0,0)
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#else
catchIO :: IO a -> (Exception.Exception -> IO a) -> IO a
#endif

#else
catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
#endif
catchIO = Exception.catch

version :: Version
version = Version [0,1,0,0] []

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir `joinFileName` name)

getBinDir, getLibDir, getDynLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath




bindir, libdir, dynlibdir, datadir, libexecdir, sysconfdir :: FilePath
bindir     = "/Users/agus/Desktop/paradigmas2024/funcional(haskell)/parciales/chocolateria/.stack-work/install/aarch64-osx/feba8ae10bd8d6e044bb08360806afe9c81406fdd8b13f992dbbbd9e0990c999/9.6.4/bin"
libdir     = "/Users/agus/Desktop/paradigmas2024/funcional(haskell)/parciales/chocolateria/.stack-work/install/aarch64-osx/feba8ae10bd8d6e044bb08360806afe9c81406fdd8b13f992dbbbd9e0990c999/9.6.4/lib/aarch64-osx-ghc-9.6.4/nombre-test-0.1.0.0-Le5YaT4al1CCq8SdLiXEz3"
dynlibdir  = "/Users/agus/Desktop/paradigmas2024/funcional(haskell)/parciales/chocolateria/.stack-work/install/aarch64-osx/feba8ae10bd8d6e044bb08360806afe9c81406fdd8b13f992dbbbd9e0990c999/9.6.4/lib/aarch64-osx-ghc-9.6.4"
datadir    = "/Users/agus/Desktop/paradigmas2024/funcional(haskell)/parciales/chocolateria/.stack-work/install/aarch64-osx/feba8ae10bd8d6e044bb08360806afe9c81406fdd8b13f992dbbbd9e0990c999/9.6.4/share/aarch64-osx-ghc-9.6.4/nombre-test-0.1.0.0"
libexecdir = "/Users/agus/Desktop/paradigmas2024/funcional(haskell)/parciales/chocolateria/.stack-work/install/aarch64-osx/feba8ae10bd8d6e044bb08360806afe9c81406fdd8b13f992dbbbd9e0990c999/9.6.4/libexec/aarch64-osx-ghc-9.6.4/nombre-test-0.1.0.0"
sysconfdir = "/Users/agus/Desktop/paradigmas2024/funcional(haskell)/parciales/chocolateria/.stack-work/install/aarch64-osx/feba8ae10bd8d6e044bb08360806afe9c81406fdd8b13f992dbbbd9e0990c999/9.6.4/etc"

getBinDir     = catchIO (getEnv "nombre_test_bindir")     (\_ -> return bindir)
getLibDir     = catchIO (getEnv "nombre_test_libdir")     (\_ -> return libdir)
getDynLibDir  = catchIO (getEnv "nombre_test_dynlibdir")  (\_ -> return dynlibdir)
getDataDir    = catchIO (getEnv "nombre_test_datadir")    (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "nombre_test_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "nombre_test_sysconfdir") (\_ -> return sysconfdir)



joinFileName :: String -> String -> FilePath
joinFileName ""  fname = fname
joinFileName "." fname = fname
joinFileName dir ""    = dir
joinFileName dir fname
  | isPathSeparator (List.last dir) = dir ++ fname
  | otherwise                       = dir ++ pathSeparator : fname

pathSeparator :: Char
pathSeparator = '/'

isPathSeparator :: Char -> Bool
isPathSeparator c = c == '/'
