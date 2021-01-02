#pragma once

#include <string>
#include <cstddef>

#if defined( _MSC_VER )
#pragma warning( push )
#pragma warning( disable : 26495 )
#pragma warning( disable : 26439 )
#endif

#include <cryptopp/rsa.h>

#if defined( _MSC_VER )
#pragma warning( pop )
#endif

#if defined( SIGNATURE_EXPORT )
#if defined( _MSC_VER )
#define SIGNATURE_EXTERN __declspec( dllexport )
#define SIGNATURE_EXTERN_C extern "C" __declspec( dllexport )
#else
#define SIGNATURE_EXTERN extern
#define SIGNATURE_EXTERN_C extern "C"
#endif
#elif defined( SIGNATURE_IMPORT )
#if defined( _MSC_VER )
#define SIGNATURE_EXTERN __declspec( dllimport )
#define SIGNATURE_EXTERN_C extern "C" __declspec( dllimport )
#else
#define SIGNATURE_EXTERN extern
#define SIGNATURE_EXTERN_C extern "C"
#endif
#else // defined( SIGNATURE_STATIC )
#define SIGNATURE_EXTERN
#define SIGNATURE_EXTERN_C extern "C"
#endif

namespace signature
{
struct KeyPairHex
{
	std::string publicKey;
	std::string privateKey;
};

SIGNATURE_EXTERN KeyPairHex RsaGenerateHexKeyPair( size_t aKeySize );

SIGNATURE_EXTERN std::string RsaSignString( const std::string &aPrivateKeyStrHex,
											const std::string &aMessage );

SIGNATURE_EXTERN bool RsaVerifyString( const std::string &aPublicKeyStrHex,
									   const std::string &aMessage,
									   const std::string &aSignatureStrHex );
}
