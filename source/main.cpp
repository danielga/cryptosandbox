#include <signature/verifier.hpp>

int main( )
{
	const signature::KeyPairHex keys = signature::RsaGenerateHexKeyPair( 4096 );
	std::cout << "Private key: " << std::endl << keys.privateKey << std::endl << std::endl;

	std::cout << "Public key: " << std::endl << keys.publicKey << std::endl << std::endl;

	const std::string message = "secret message";
	std::cout << "Message:" << std::endl;
	std::cout << message << std::endl << std::endl;

	// generate a signature for the message
	const std::string signature = signature::RsaSignString( keys.privateKey, message );
	std::cout << "Signature:" << std::endl;
	std::cout << signature << std::endl << std::endl;

	// verify signature against public key
	if( signature::RsaVerifyString( keys.publicKey, message, signature ) )
		std::cout << "Signature valid." << std::endl;
	else
		std::cout << "Signature invalid." << std::endl;

	return 0;
}
