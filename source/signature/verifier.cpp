#include "verifier.hpp"

#include <cryptopp/osrng.h>
#include <cryptopp/hex.h>
#include <cryptopp/pssr.h>

namespace signature
{
KeyPairHex RsaGenerateHexKeyPair( size_t aKeySize )
{
	KeyPairHex keyPair;

	// PGP Random Pool-like generator
	CryptoPP::AutoSeededRandomPool rng;

	// generate keys
	CryptoPP::RSA::PrivateKey privateKey;
	privateKey.GenerateRandomWithKeySize( rng, aKeySize );
	CryptoPP::RSA::PublicKey publicKey( privateKey );

	// save keys
	publicKey.Save( CryptoPP::HexEncoder(
		new CryptoPP::StringSink( keyPair.publicKey ) ).Ref( ) );
	privateKey.Save( CryptoPP::HexEncoder(
		new CryptoPP::StringSink( keyPair.privateKey ) ).Ref( ) );

	return keyPair;
}

std::string RsaSignString( const std::string &aPrivateKeyStrHex,
						   const std::string &aMessage )
{
	// decode and load private key (using pipeline)
	CryptoPP::RSA::PrivateKey privateKey;
	privateKey.Load( CryptoPP::StringSource( aPrivateKeyStrHex, true,
											 new CryptoPP::HexDecoder( ) ).Ref( ) );

	// sign message
	std::string signature;
	CryptoPP::RSASSA_PKCS1v15_SHA_Signer signer( privateKey );
	CryptoPP::AutoSeededRandomPool rng;

	CryptoPP::StringSource ss( aMessage, true,
							   new CryptoPP::SignerFilter( rng, signer,
														   new CryptoPP::HexEncoder(
															   new CryptoPP::StringSink( signature ) ) ) );

	return signature;
}

bool RsaVerifyString( const std::string &aPublicKeyStrHex,
					  const std::string &aMessage,
					  const std::string &aSignatureStrHex )
{
	// decode and load public key (using pipeline)
	CryptoPP::RSA::PublicKey publicKey;
	publicKey.Load( CryptoPP::StringSource( aPublicKeyStrHex, true,
											new CryptoPP::HexDecoder( ) ).Ref( ) );

	// decode signature
	std::string decodedSignature;
	CryptoPP::StringSource ss( aSignatureStrHex, true,
							   new CryptoPP::HexDecoder(
								   new CryptoPP::StringSink( decodedSignature ) ) );

	// verify message
	bool result = false;
	CryptoPP::RSASSA_PKCS1v15_SHA_Verifier verifier( publicKey );
	CryptoPP::StringSource ss2( decodedSignature + aMessage, true,
								new CryptoPP::SignatureVerificationFilter( verifier,
																		   new CryptoPP::ArraySink( reinterpret_cast<CryptoPP::byte *>( &result ),
																									sizeof( result ) ) ) );

	return result;
}
}
