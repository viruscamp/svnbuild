if not exist %APDIR%\bin goto AP_INS_END

@rem libapr-1.dll libapriconv-1.dll libaprutil-1.dll
xcopy %APDIR%\bin\libapr*.dll %INSDIR%\bin /s /e /q /h /r /y

@rem only needed by svn crypto_test
xcopy %APDIR%\bin\apr_crypto_openssl*.dll %INSDIR%\bin /s /e /q /h /r /y

@rem openssl-1.1 openssl-3.0 files needed by apr_crypto_openssl
xcopy %APDIR%\bin\libcrypto-*.dll %INSDIR%\bin /s /e /q /h /r /y
xcopy %APDIR%\bin\libssl-*.dll %INSDIR%\bin /s /e /q /h /r /y

@rem openssl-1.0 files needed by apr_crypto_openssl
xcopy %APDIR%\bin\libeay32.dll %INSDIR%\bin /s /e /q /h /r /y
xcopy %APDIR%\bin\ssleay32.dll.dll %INSDIR%\bin /s /e /q /h /r /y


if exist %APDIR%\bin\iconv goto AP_BIN_ICONV
if exist %APDIR%\iconv goto AP_ICONV
echo cannot find iconv dir
goto AP_INS_END

:AP_BIN_ICONV
mkdir %INSDIR%\bin\iconv
xcopy %APDIR%\bin\iconv\*.so %INSDIR%\bin\iconv\ /s /e /q /h /r /y
goto AP_INS_END

:AP_ICONV
mkdir %INSDIR%\iconv
xcopy %APDIR%\iconv\*.so %INSDIR%\iconv\ /s /e /q /h /r /y
goto AP_INS_END

:AP_INS_END
