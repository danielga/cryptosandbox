#ifdef CRYPTOPP_IMPORTS
#include <cryptopp/dll.h>

static CryptoPP::PNew s_pNew = nullptr;
static CryptoPP::PDelete s_pDelete = nullptr;

extern "C" __declspec( dllexport ) void __cdecl SetNewAndDeleteFromCryptoPP( CryptoPP::PNew pNew, CryptoPP::PDelete pDelete, CryptoPP::PSetNewHandler )
{
	s_pNew = pNew;
	s_pDelete = pDelete;
}

void *__cdecl operator new( size_t size )
{
	return s_pNew( size );
}

void __cdecl operator delete( void *p )
{
	s_pDelete( p );
}
#endif
