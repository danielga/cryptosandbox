project("cryptopp")
	uuid("56A1D28D-90AF-4924-8781-0811439E03C2")
	language("C++")
	cdialect("C11")
	cppdialect("C++17")
	warnings("Extra")
	flags("MultiProcessorCompile")
	exceptionhandling("SEH")
	characterset("MBCS")
	intrinsics("On")
	inlining("Auto")
	rtti("On")
	vectorextensions("AVX2")
	pic("On")
	location("projects/%{os.target()}/%{_ACTION}")
	targetdir("%{prj.location}/%{cfg.platform}/%{cfg.buildcfg}")
	debugdir("%{prj.location}/%{cfg.platform}/%{cfg.buildcfg}")
	objdir("!%{prj.location}/%{cfg.platform}/%{cfg.buildcfg}/intermediate")
	platforms({"x86", "x86_64"})
	configurations({"release", "debug", "release-static", "debug-static"})
	includedirs("cryptopp")
	pchheader("pch.h")
	pchsource("cryptopp/pch.cpp")
	vpaths({
		["Header files"] = {
			"cryptopp/**.h",
			"cryptopp-pem/**.h"
		},
		["Source files"] = {
			"cryptopp/**.asm",
			"cryptopp/**.cpp",
			"cryptopp-pem/**.cpp"
		}
	})
	files({
		"cryptopp/algebra.cpp",
		"cryptopp/algparam.cpp",
		"cryptopp/allocate.cpp",
		"cryptopp/asn.cpp",
		"cryptopp/authenc.cpp",
		"cryptopp/basecode.cpp",
		"cryptopp/cbcmac.cpp",
		"cryptopp/ccm.cpp",
		"cryptopp/channels.cpp",
		"cryptopp/cmac.cpp",
		"cryptopp/cpu.cpp",
		"cryptopp/cryptlib.cpp",
		"cryptopp/des.cpp",
		"cryptopp/dessp.cpp",
		"cryptopp/dh.cpp",
		"cryptopp/dll.cpp",
		"cryptopp/dsa.cpp",
		"cryptopp/ec2n.cpp",
		"cryptopp/eccrypto.cpp",
		"cryptopp/ecp.cpp",
		"cryptopp/emsa2.cpp",
		"cryptopp/eprecomp.cpp",
		"cryptopp/files.cpp",
		"cryptopp/filters.cpp",
		"cryptopp/fips140.cpp",
		"cryptopp/fipstest.cpp",
		"cryptopp/gcm.cpp",
		"cryptopp/gcm_simd.cpp",
		"cryptopp/gf2n.cpp",
		"cryptopp/gf2n_simd.cpp",
		"cryptopp/gfpcrypt.cpp",
		"cryptopp/hex.cpp",
		"cryptopp/hmac.cpp",
		"cryptopp/hrtimer.cpp",
		"cryptopp/integer.cpp",
		"cryptopp/iterhash.cpp",
		"cryptopp/misc.cpp",
		"cryptopp/modes.cpp",
		"cryptopp/mqueue.cpp",
		"cryptopp/nbtheory.cpp",
		"cryptopp/oaep.cpp",
		"cryptopp/osrng.cpp",
		"cryptopp/pch.cpp",
		"cryptopp/pkcspad.cpp",
		"cryptopp/pssr.cpp",
		"cryptopp/pubkey.cpp",
		"cryptopp/queue.cpp",
		"cryptopp/randpool.cpp",
		"cryptopp/rdtables.cpp",
		"cryptopp/rijndael.cpp",
		"cryptopp/rijndael_simd.cpp",
		"cryptopp/rng.cpp",
		"cryptopp/rsa.cpp",
		"cryptopp/rw.cpp",
		"cryptopp/sha.cpp",
		"cryptopp/sha_simd.cpp",
		"cryptopp/simple.cpp",
		"cryptopp/skipjack.cpp",
		"cryptopp/sse_simd.cpp",
		"cryptopp/strciphr.cpp",

		"cryptopp/aes.h",
		"cryptopp/algebra.h",
		"cryptopp/algparam.h",
		"cryptopp/allocate.h",
		"cryptopp/argnames.h",
		"cryptopp/asn.h",
		"cryptopp/authenc.h",
		"cryptopp/basecode.h",
		"cryptopp/cbcmac.h",
		"cryptopp/ccm.h",
		"cryptopp/channels.h",
		"cryptopp/cmac.h",
		"cryptopp/config.h",
		"cryptopp/config_align.h",
		"cryptopp/config_asm.h",
		"cryptopp/config_cpu.h",
		"cryptopp/config_cxx.h",
		"cryptopp/config_dll.h",
		"cryptopp/config_int.h",
		"cryptopp/config_misc.h",
		"cryptopp/config_ns.h",
		"cryptopp/config_os.h",
		"cryptopp/config_ver.h",
		"cryptopp/cpu.h",
		"cryptopp/cryptlib.h",
		"cryptopp/des.h",
		"cryptopp/dh.h",
		"cryptopp/dll.h",
		"cryptopp/dsa.h",
		"cryptopp/ec2n.h",
		"cryptopp/eccrypto.h",
		"cryptopp/ecp.h",
		"cryptopp/ecpoint.h",
		"cryptopp/emsa2.h",
		"cryptopp/eprecomp.h",
		"cryptopp/files.h",
		"cryptopp/filters.h",
		"cryptopp/fips140.h",
		"cryptopp/fltrimpl.h",
		"cryptopp/gcm.h",
		"cryptopp/gf2n.h",
		"cryptopp/gfpcrypt.h",
		"cryptopp/hex.h",
		"cryptopp/hmac.h",
		"cryptopp/integer.h",
		"cryptopp/iterhash.h",
		"cryptopp/mdc.h",
		"cryptopp/misc.h",
		"cryptopp/modarith.h",
		"cryptopp/modes.h",
		"cryptopp/modexppc.h",
		"cryptopp/mqueue.h",
		"cryptopp/mqv.h",
		"cryptopp/nbtheory.h",
		"cryptopp/oaep.h",
		"cryptopp/oids.h",
		"cryptopp/osrng.h",
		"cryptopp/pch.h",
		"cryptopp/pkcspad.h",
		"cryptopp/pssr.h",
		"cryptopp/pubkey.h",
		"cryptopp/queue.h",
		"cryptopp/randpool.h",
		"cryptopp/rijndael.h",
		"cryptopp/rng.h",
		"cryptopp/rsa.h",
		"cryptopp/rw.h",
		"cryptopp/secblock.h",
		"cryptopp/seckey.h",
		"cryptopp/sha.h",
		"cryptopp/simple.h",
		"cryptopp/skipjack.h",
		"cryptopp/smartptr.h",
		"cryptopp/stdcpp.h",
		"cryptopp/strciphr.h",
		"cryptopp/trap.h",
		"cryptopp/words.h",

		"cryptopp-pem/x509cert.cpp",
		"cryptopp-pem/x509cert.h"
	})

	filter("platforms:x86")
		architecture("x86")

	filter("platforms:x86_64")
		architecture("x86_64")

	filter("configurations:release")
		defines("NDEBUG")
		optimize("On")
		kind("SharedLib")

	filter("configurations:debug")
		defines({"DEBUG", "_DEBUG"})
		symbols("On")
		kind("SharedLib")

	filter("configurations:release-static")
		defines("NDEBUG")
		optimize("On")
		kind("StaticLib")

	filter("configurations:debug-static")
		defines({"DEBUG", "_DEBUG"})
		symbols("On")
		kind("StaticLib")

	filter("configurations:debug or release")
		defines("CRYPTOPP_EXPORTS")

	filter("configurations:debug-static or release-static")
		files({
			"cryptopp/3way.cpp",
			"cryptopp/adler32.cpp",
			"cryptopp/arc4.cpp",
			"cryptopp/aria.cpp",
			"cryptopp/aria_simd.cpp",
			"cryptopp/ariatab.cpp",
			"cryptopp/base32.cpp",
			"cryptopp/base64.cpp",
			"cryptopp/bfinit.cpp",
			"cryptopp/blake2.cpp",
			"cryptopp/blake2s_simd.cpp",
			"cryptopp/blake2b_simd.cpp",
			"cryptopp/blowfish.cpp",
			"cryptopp/blumshub.cpp",
			"cryptopp/camellia.cpp",
			"cryptopp/cast.cpp",
			"cryptopp/casts.cpp",
			"cryptopp/chacha.cpp",
			"cryptopp/chacha_simd.cpp",
			"cryptopp/chacha_avx.cpp",
			"cryptopp/chachapoly.cpp",
			"cryptopp/cham.cpp",
			"cryptopp/cham_simd.cpp",
			"cryptopp/crc.cpp",
			"cryptopp/crc_simd.cpp",
			"cryptopp/darn.cpp",
			"cryptopp/default.cpp",
			"cryptopp/dh2.cpp",
			"cryptopp/donna_32.cpp",
			"cryptopp/donna_64.cpp",
			"cryptopp/donna_sse.cpp",
			"cryptopp/eax.cpp",
			"cryptopp/elgamal.cpp",
			"cryptopp/esign.cpp",
			"cryptopp/gf256.cpp",
			"cryptopp/gf2_32.cpp",
			"cryptopp/gost.cpp",
			"cryptopp/gzip.cpp",
			"cryptopp/hc128.cpp",
			"cryptopp/hc256.cpp",
			"cryptopp/hight.cpp",
			"cryptopp/ida.cpp",
			"cryptopp/idea.cpp",
			"cryptopp/kalyna.cpp",
			"cryptopp/kalynatab.cpp",
			"cryptopp/keccak.cpp",
			"cryptopp/keccak_core.cpp",
			"cryptopp/keccak_simd.cpp",
			"cryptopp/lea.cpp",
			"cryptopp/lea_simd.cpp",
			"cryptopp/luc.cpp",
			"cryptopp/mars.cpp",
			"cryptopp/marss.cpp",
			"cryptopp/md2.cpp",
			"cryptopp/md4.cpp",
			"cryptopp/md5.cpp",
			"cryptopp/mqv.cpp",
			"cryptopp/padlkrng.cpp",
			"cryptopp/panama.cpp",
			"cryptopp/poly1305.cpp",
			"cryptopp/polynomi.cpp",
			"cryptopp/rabin.cpp",
			"cryptopp/rabbit.cpp",
			"cryptopp/rc2.cpp",
			"cryptopp/rc5.cpp",
			"cryptopp/rc6.cpp",
			"cryptopp/rdrand.cpp",
			"cryptopp/ripemd.cpp",
			"cryptopp/safer.cpp",
			"cryptopp/salsa.cpp",
			"cryptopp/scrypt.cpp",
			"cryptopp/seal.cpp",
			"cryptopp/seed.cpp",
			"cryptopp/serpent.cpp",
			"cryptopp/sha3.cpp",
			"cryptopp/shacal2.cpp",
			"cryptopp/shacal2_simd.cpp",
			"cryptopp/shake.cpp",
			"cryptopp/shark.cpp",
			"cryptopp/sharkbox.cpp",
			"cryptopp/simeck.cpp",
			"cryptopp/simon.cpp",
			"cryptopp/simon128_simd.cpp",
			"cryptopp/sm3.cpp",
			"cryptopp/sm4.cpp",
			"cryptopp/sm4_simd.cpp",
			"cryptopp/sosemanuk.cpp",
			"cryptopp/speck.cpp",
			"cryptopp/speck128_simd.cpp",
			"cryptopp/square.cpp",
			"cryptopp/squaretb.cpp",
			"cryptopp/tea.cpp",
			"cryptopp/tftables.cpp",
			"cryptopp/threefish.cpp",
			"cryptopp/tiger.cpp",
			"cryptopp/tigertab.cpp",
			"cryptopp/ttmac.cpp",
			"cryptopp/tweetnacl.cpp",
			"cryptopp/twofish.cpp",
			"cryptopp/vmac.cpp",
			"cryptopp/wake.cpp",
			"cryptopp/whrlpool.cpp",
			"cryptopp/xed25519.cpp",
			"cryptopp/xtr.cpp",
			"cryptopp/xtrcrypt.cpp",
			"cryptopp/xts.cpp",
			"cryptopp/zdeflate.cpp",
			"cryptopp/zinflate.cpp",
			"cryptopp/zlib.cpp",

			"cryptopp/3way.h",
			"cryptopp/adler32.h",
			"cryptopp/adv_simd.h",
			"cryptopp/arc4.h",
			"cryptopp/aria.h",
			"cryptopp/base32.h",
			"cryptopp/base64.h",
			"cryptopp/blake2.h",
			"cryptopp/blowfish.h",
			"cryptopp/blumshub.h",
			"cryptopp/camellia.h",
			"cryptopp/cast.h",
			"cryptopp/chacha.h",
			"cryptopp/chachapoly.h",
			"cryptopp/cham.h",
			"cryptopp/crc.h",
			"cryptopp/darn.h",
			"cryptopp/default.h",
			"cryptopp/dh2.h",
			"cryptopp/dmac.h",
			"cryptopp/drbg.h",
			"cryptopp/donna.h",
			"cryptopp/donna_32.h",
			"cryptopp/donna_64.h",
			"cryptopp/donna_sse.h",
			"cryptopp/eax.h",
			"cryptopp/elgamal.h",
			"cryptopp/esign.h",
			"cryptopp/fhmqv.h",
			"cryptopp/gf256.h",
			"cryptopp/gf2_32.h",
			"cryptopp/gost.h",
			"cryptopp/gzip.h",
			"cryptopp/hc128.h",
			"cryptopp/hc256.h",
			"cryptopp/hight.h",
			"cryptopp/hkdf.h",
			"cryptopp/hmqv.h",
			"cryptopp/hrtimer.h",
			"cryptopp/ida.h",
			"cryptopp/idea.h",
			"cryptopp/kalyna.h",
			"cryptopp/keccak.h",
			"cryptopp/lubyrack.h",
			"cryptopp/lea.h",
			"cryptopp/luc.h",
			"cryptopp/mars.h",
			"cryptopp/md2.h",
			"cryptopp/md4.h",
			"cryptopp/md5.h",
			"cryptopp/naclite.h",
			"cryptopp/nr.h",
			"cryptopp/padlkrng.h",
			"cryptopp/panama.h",
			"cryptopp/poly1305.h",
			"cryptopp/polynomi.h",
			"cryptopp/pwdbased.h",
			"cryptopp/rabin.h",
			"cryptopp/rabbit.h",
			"cryptopp/rc2.h",
			"cryptopp/rc5.h",
			"cryptopp/rc6.h",
			"cryptopp/rdrand.h",
			"cryptopp/ripemd.h",
			"cryptopp/safer.h",
			"cryptopp/salsa.h",
			"cryptopp/scrypt.h",
			"cryptopp/seal.h",
			"cryptopp/secblockfwd.h",
			"cryptopp/seed.h",
			"cryptopp/serpent.h",
			"cryptopp/sha3.h",
			"cryptopp/shacal2.h",
			"cryptopp/shake.h",
			"cryptopp/shark.h",
			"cryptopp/simeck.h",
			"cryptopp/simon.h",
			"cryptopp/siphash.h",
			"cryptopp/sm3.h",
			"cryptopp/sm4.h",
			"cryptopp/sosemanuk.h",
			"cryptopp/speck.h",
			"cryptopp/square.h",
			"cryptopp/tea.h",
			"cryptopp/threefish.h",
			"cryptopp/tiger.h",
			"cryptopp/trunhash.h",
			"cryptopp/ttmac.h",
			"cryptopp/tweetnacl.h",
			"cryptopp/twofish.h",
			"cryptopp/vmac.h",
			"cryptopp/wake.h",
			"cryptopp/whrlpool.h",
			"cryptopp/xed25519.h",
			"cryptopp/xtr.h",
			"cryptopp/xtrcrypt.h",
			"cryptopp/xts.h",
			"cryptopp/zdeflate.h",
			"cryptopp/zinflate.h",
			"cryptopp/zlib.h"
		})

		filter({"configurations:debug-static or release-static", "system:windows", "platforms:x86_64"})
			files("cryptopp/x64masm.asm")

		filter({"configurations:debug-static or release-static", "files:cryptopp/eccrypto.cpp or cryptopp/eprecomp.cpp"})
			flags("ExcludeFromBuild")

	filter("files:cryptopp/fipstest.cpp")
		flags("ExcludeFromBuild")

	filter("files:cryptopp/dll.cpp or cryptopp/iterhash.cpp or cryptopp-pem/x509cert.cpp")
		flags("NoPCH")

	filter("system:windows")
		disablewarnings({"4251", "4275"})
		defines({
			"WINVER=0x0601",
			"_WIN32_WINNT=0x0601",
			"STRICT",
			"_CRT_NONSTDC_NO_WARNINGS",
			"_CRT_SECURE_NO_WARNINGS"
		})
		files({"cryptopp/rdrand.asm", "cryptopp/rdseed.asm"})

		filter({"system:windows", "platforms:x86_64"})
			files("cryptopp/x64dll.asm")

		filter({"system:windows", "files:cryptopp/rdrand.asm or cryptopp/rdseed.asm"})
			buildmessage("Assembling %{file.relpath}")
			buildoutputs("%{cfg.objdir}/%{file.basename}-%{cfg.platform}.obj")

			filter({"system:windows", "files:cryptopp/rdrand.asm or cryptopp/rdseed.asm", "platforms:x86"})
				buildcommands("ml /c /nologo /D_M_X86 /W3 /Cx /Zi /safeseh /Fo \"%{cfg.objdir}/%{file.basename}-%{cfg.platform}.obj\" \"%{file.relpath}\"")

			filter({"system:windows", "files:cryptopp/rdrand.asm or cryptopp/rdseed.asm", "platforms:x86_64"})
				buildcommands("ml64 /c /nologo /D_M_X64 /W3 /Cx /Zi /Fo \"%{cfg.objdir}/%{file.basename}-%{cfg.platform}.obj\" \"%{file.relpath}\"")

		filter({"system:windows", "files:cryptopp/x64dll.asm", "platforms:x86_64"})
			buildmessage("Assembling %{file.relpath}")
			buildcommands("ml64 /c /nologo /D_M_X64 /W3 /Zi /Fo \"%{cfg.objdir}/%{file.basename}.obj\" \"%{file.relpath}\"")
			buildoutputs("%{cfg.objdir}/%{file.basename}.obj")

		filter({"system:windows", "files:cryptopp/x64masm.asm", "platforms:x86_64", "configurations:debug or release"})
			buildmessage("Assembling %{file.relpath}")
			buildcommands("ml64 /c /nologo /D_M_X64 /W3 /Zi /Fo \"%{cfg.objdir}/%{file.basename}.obj\" \"%{file.relpath}\"")
			buildoutputs("%{cfg.objdir}/%{file.basename}.obj")
