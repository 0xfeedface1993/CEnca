//
//  File.swift
//  
//
//  Created by john on 2023/8/18.
//

import Foundation

#if os(Linux)

enum CFStringEncodings : UInt, @unchecked Sendable {

    
    /*  kCFStringEncodingMacRoman = 0L, defined in CoreFoundation/CFString.h */
    case macJapanese = 1

    case macChineseTrad = 2

    case macKorean = 3

    case macArabic = 4

    case macHebrew = 5

    case macGreek = 6

    case macCyrillic = 7

    case macDevanagari = 9

    case macGurmukhi = 10

    case macGujarati = 11

    case macOriya = 12

    case macBengali = 13

    case macTamil = 14

    case macTelugu = 15

    case macKannada = 16

    case macMalayalam = 17

    case macSinhalese = 18

    case macBurmese = 19

    case macKhmer = 20

    case macThai = 21

    case macLaotian = 22

    case macGeorgian = 23

    case macArmenian = 24

    case macChineseSimp = 25

    case macTibetan = 26

    case macMongolian = 27

    case macEthiopic = 28

    case macCentralEurRoman = 29

    case macVietnamese = 30

    case macExtArabic = 31

    /* The following use script code 0, smRoman */
    case macSymbol = 33

    case macDingbats = 34

    case macTurkish = 35

    case macCroatian = 36

    case macIcelandic = 37

    case macRomanian = 38

    case macCeltic = 39

    case macGaelic = 40

    /* The following use script code 4, smArabic */
    case macFarsi = 140 /* Like MacArabic but uses Farsi digits */

    /* The following use script code 7, smCyrillic */
    case macUkrainian = 152

    /* The following use script code 32, smUnimplemented */
    case macInuit = 236

    case macVT100 = 252 /* VT100/102 font from Comm Toolbox: Latin-1 repertoire + box drawing etc */

    /* Special Mac OS encodings*/
    case macHFS = 255 /* Meta-value, should never appear in a table */

    
    /* Unicode & ISO UCS encodings begin at 0x100 */
    /* We don't use Unicode variations defined in TextEncoding; use the ones in CFString.h, instead. */
    
    /* ISO 8-bit and 7-bit encodings begin at 0x200 */
    /*  kCFStringEncodingISOLatin1 = 0x0201, defined in CoreFoundation/CFString.h */
    case isoLatin2 = 514 /* ISO 8859-2 */

    case isoLatin3 = 515 /* ISO 8859-3 */

    case isoLatin4 = 516 /* ISO 8859-4 */

    case isoLatinCyrillic = 517 /* ISO 8859-5 */

    case isoLatinArabic = 518 /* ISO 8859-6, =ASMO 708, =DOS CP 708 */

    case isoLatinGreek = 519 /* ISO 8859-7 */

    case isoLatinHebrew = 520 /* ISO 8859-8 */

    case isoLatin5 = 521 /* ISO 8859-9 */

    case isoLatin6 = 522 /* ISO 8859-10 */

    case isoLatinThai = 523 /* ISO 8859-11 */

    case isoLatin7 = 525 /* ISO 8859-13 */

    case isoLatin8 = 526 /* ISO 8859-14 */

    case isoLatin9 = 527 /* ISO 8859-15 */

    case isoLatin10 = 528 /* ISO 8859-16 */

    
    /* MS-DOS & Windows encodings begin at 0x400 */
    case dosLatinUS = 1024 /* code page 437 */

    case dosGreek = 1029 /* code page 737 (formerly code page 437G) */

    case dosBalticRim = 1030 /* code page 775 */

    case dosLatin1 = 1040 /* code page 850, "Multilingual" */

    case dosGreek1 = 1041 /* code page 851 */

    case dosLatin2 = 1042 /* code page 852, Slavic */

    case dosCyrillic = 1043 /* code page 855, IBM Cyrillic */

    case dosTurkish = 1044 /* code page 857, IBM Turkish */

    case dosPortuguese = 1045 /* code page 860 */

    case dosIcelandic = 1046 /* code page 861 */

    case dosHebrew = 1047 /* code page 862 */

    case dosCanadianFrench = 1048 /* code page 863 */

    case dosArabic = 1049 /* code page 864 */

    case dosNordic = 1050 /* code page 865 */

    case dosRussian = 1051 /* code page 866 */

    case dosGreek2 = 1052 /* code page 869, IBM Modern Greek */

    case dosThai = 1053 /* code page 874, also for Windows */

    case dosJapanese = 1056 /* code page 932, also for Windows */

    case dosChineseSimplif = 1057 /* code page 936, also for Windows */

    case dosKorean = 1058 /* code page 949, also for Windows; Unified Hangul Code */

    case dosChineseTrad = 1059 /* code page 950, also for Windows */

    /*  kCFStringEncodingWindowsLatin1 = 0x0500, defined in CoreFoundation/CFString.h */
    case windowsLatin2 = 1281 /* code page 1250, Central Europe */

    case windowsCyrillic = 1282 /* code page 1251, Slavic Cyrillic */

    case windowsGreek = 1283 /* code page 1253 */

    case windowsLatin5 = 1284 /* code page 1254, Turkish */

    case windowsHebrew = 1285 /* code page 1255 */

    case windowsArabic = 1286 /* code page 1256 */

    case windowsBalticRim = 1287 /* code page 1257 */

    case windowsVietnamese = 1288 /* code page 1258 */

    case windowsKoreanJohab = 1296 /* code page 1361, for Windows NT */

    
    /* Various national standards begin at 0x600 */
    /*  kCFStringEncodingASCII = 0x0600, defined in CoreFoundation/CFString.h */
    case ANSEL = 1537 /* ANSEL (ANSI Z39.47) */

    case JIS_X0201_76 = 1568

    case JIS_X0208_83 = 1569

    case JIS_X0208_90 = 1570

    case JIS_X0212_90 = 1571

    case JIS_C6226_78 = 1572

    @available(macOS 10.5, *)
    case shiftJIS_X0213 = 1576 /* Shift-JIS format encoding of JIS X0213 planes 1 and 2*/

    case shiftJIS_X0213_MenKuTen = 1577 /* JIS X0213 in plane-row-column notation */

    case GB_2312_80 = 1584

    case GBK_95 = 1585 /* annex to GB 13000-93; for Windows 95 */

    case GB_18030_2000 = 1586

    case KSC_5601_87 = 1600 /* same as KSC 5601-92 without Johab annex */

    case ksc_5601_92_Johab = 1601 /* KSC 5601-92 Johab annex */

    case CNS_11643_92_P1 = 1617 /* CNS 11643-1992 plane 1 */

    case CNS_11643_92_P2 = 1618 /* CNS 11643-1992 plane 2 */

    case CNS_11643_92_P3 = 1619 /* CNS 11643-1992 plane 3 (was plane 14 in 1986 version) */

    
    /* ISO 2022 collections begin at 0x800 */
    case ISO_2022_JP = 2080

    case ISO_2022_JP_2 = 2081

    case ISO_2022_JP_1 = 2082 /* RFC 2237*/

    case ISO_2022_JP_3 = 2083 /* JIS X0213*/

    case ISO_2022_CN = 2096

    case ISO_2022_CN_EXT = 2097

    case ISO_2022_KR = 2112

    
    /* EUC collections begin at 0x900 */
    case EUC_JP = 2336 /* ISO 646, 1-byte katakana, JIS 208, JIS 212 */

    case EUC_CN = 2352 /* ISO 646, GB 2312-80 */

    case EUC_TW = 2353 /* ISO 646, CNS 11643-1992 Planes 1-16 */

    case EUC_KR = 2368 /* ISO 646, KS C 5601-1987 */

    
    /* Misc standards begin at 0xA00 */
    case shiftJIS = 2561 /* plain Shift-JIS */

    case KOI8_R = 2562 /* Russian internet standard */

    case big5 = 2563 /* Big-5 (has variants) */

    case macRomanLatin1 = 2564 /* Mac OS Roman permuted to align with ISO Latin-1 */

    case HZ_GB_2312 = 2565 /* HZ (RFC 1842, for Chinese mail & news) */

    case big5_HKSCS_1999 = 2566 /* Big-5 with Hong Kong special char set supplement*/

    case VISCII = 2567 /* RFC 1456, Vietnamese */

    case KOI8_U = 2568 /* RFC 2319, Ukrainian */

    case big5_E = 2569 /* Taiwan Big-5E standard */

    
    /* Other platform encodings*/
    /*  kCFStringEncodingNextStepLatin = 0x0B01, defined in CoreFoundation/CFString.h */
    case nextStepJapanese = 2818 /* NextStep Japanese encoding */

    
    /* EBCDIC & IBM host encodings begin at 0xC00 */
    case EBCDIC_US = 3073 /* basic EBCDIC-US */

    case EBCDIC_CP037 = 3074 /* code page 037, extended EBCDIC (Latin-1 set) for US,Canada... */

    
    @available(macOS 10.6, *)
    case UTF7 = 67109120 /* kTextEncodingUnicodeDefault + kUnicodeUTF7Format RFC2152 */

    @available(macOS 10.6, *)
    case UTF7_IMAP = 2576 /* UTF-7 (IMAP folder variant) RFC3501 */

    
    /* Deprecated constants */
//    public static var shiftJIS_X0213_00: CFStringEncodings { get } /* Shift-JIS format encoding of JIS X0213 planes 1 and 2 (DEPRECATED) */
}

#endif

extension CFStringEncodings {
    /// Computed property that returns the corresponding String.Encoding for a given CFStringEncodings value.
    var mappingEncoding: String.Encoding {
        .init(rawValue: UInt(rawValue))
    }
}
