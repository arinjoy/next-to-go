//
//  Created by Arinjoy Biswas on 18/6/2023.
//

import Foundation

public struct CountryUtilities {

    /// 🙏🏽 Courtesy:
    /** https://stackoverflow.com/questions/6447242/always-get-iso-639-2-three-character-language-code-in-ios
    */
    public static func getAlpha3Code(byAlpha2Code alpha2code: String) -> String? {
        return countries[alpha2code]?.uppercased()
    }

    public static func getAlpha2Code(byAlpha3Code alpha3code: String) -> String? {
        return countries.key(forValue: alpha3code)?.uppercased()
    }

    /// 🙏🏽 Courtesy:
    /**
     https://stackoverflow.com/questions/30402435/swift-turn-a-country-code-into-a-emoji-flag-via-unicode
     */
    public static func countryFlag(byAlphaCode alphaCode: String) -> String? {
        var alpha2code: String?

        if alphaCode.count == 3 {
            alpha2code = getAlpha2Code(byAlpha3Code: alphaCode)
        } else if alphaCode.count == 2 {
            if alphaCode == "UK" {
                alpha2code = "GB" // Exception rule for UK
            } else {
                alpha2code = alphaCode
            }
        }

        guard let alpha2code else { return nil }

        let base: UInt32 = 127397
        var s = ""
        for v in alpha2code.unicodeScalars {
            guard let scalar = UnicodeScalar(base + v.value) else {
                return nil
            }
            s.unicodeScalars.append(scalar)
        }
        return String(s)
    }

    private static let countries: [String: String] = [
        "AF": "AFG",
        "AX": "ALA",
        "AL": "ALB",
        "DZ": "DZA",
        "AS": "ASM",
        "AD": "AND",
        "AO": "AGO",
        "AI": "AIA",
        "AQ": "ATA",
        "AG": "ATG",
        "AR": "ARG",
        "AM": "ARM",
        "AW": "ABW",
        "AU": "AUS",
        "AT": "AUT",
        "AZ": "AZE",
        "BS": "BHS",
        "BH": "BHR",
        "BD": "BGD",
        "BB": "BRB",
        "BY": "BLR",
        "BE": "BEL",
        "BZ": "BLZ",
        "BJ": "BEN",
        "BM": "BMU",
        "BT": "BTN",
        "BO": "BOL",
        "BQ": "BES",
        "BA": "BIH",
        "BW": "BWA",
        "BV": "BVT",
        "BR": "BRA",
        "IO": "IOT",
        "BN": "BRN",
        "BG": "BGR",
        "BF": "BFA",
        "BI": "BDI",
        "CV": "CPV",
        "KH": "KHM",
        "CM": "CMR",
        "CA": "CAN",
        "KY": "CYM",
        "CF": "CAF",
        "TD": "TCD",
        "CL": "CHL",
        "CN": "CHN",
        "CX": "CXR",
        "CC": "CCK",
        "CO": "COL",
        "KM": "COM",
        "CG": "COG",
        "CD": "COD",
        "CK": "COK",
        "CR": "CRI",
        "CI": "CIV",
        "HR": "HRV",
        "CU": "CUB",
        "CW": "CUW",
        "CY": "CYP",
        "CZ": "CZE",
        "DK": "DNK",
        "DJ": "DJI",
        "DM": "DMA",
        "DO": "DOM",
        "EC": "ECU",
        "EG": "EGY",
        "SV": "SLV",
        "GQ": "GNQ",
        "ER": "ERI",
        "EE": "EST",
        "SZ": "SWZ",
        "ET": "ETH",
        "FK": "FLK",
        "FO": "FRO",
        "FJ": "FJI",
        "FI": "FIN",
        "FR": "FRA",
        "GF": "GUF",
        "PF": "PYF",
        "TF": "ATF",
        "GA": "GAB",
        "GM": "GMB",
        "GE": "GEO",
        "DE": "DEU",
        "GH": "GHA",
        "GI": "GIB",
        "GR": "GRC",
        "GL": "GRL",
        "GD": "GRD",
        "GP": "GLP",
        "GU": "GUM",
        "GT": "GTM",
        "GG": "GGY",
        "GN": "GIN",
        "GW": "GNB",
        "GY": "GUY",
        "HT": "HTI",
        "HM": "HMD",
        "VA": "VAT",
        "HN": "HND",
        "HK": "HKG",
        "HU": "HUN",
        "IS": "ISL",
        "IN": "IND",
        "ID": "IDN",
        "IR": "IRN",
        "IQ": "IRQ",
        "IE": "IRE",
        "IM": "IMN",
        "IL": "ISR",
        "IT": "ITA",
        "JM": "JAM",
        "JP": "JPN",
        "JE": "JEY",
        "JO": "JOR",
        "KZ": "KAZ",
        "KE": "KEN",
        "KI": "KIR",
        "KP": "PRK",
        "KR": "KOR",
        "KW": "KWT",
        "KG": "KGZ",
        "LA": "LAO",
        "LV": "LVA",
        "LB": "LBN",
        "LS": "LSO",
        "LR": "LBR",
        "LY": "LBY",
        "LI": "LIE",
        "LT": "LTU",
        "LU": "LUX",
        "MO": "MAC",
        "MK": "MKD",
        "MG": "MDG",
        "MW": "MWI",
        "MY": "MYS",
        "MV": "MDV",
        "ML": "MLI",
        "MT": "MLT",
        "MH": "MHL",
        "MQ": "MTQ",
        "MR": "MRT",
        "MU": "MUS",
        "YT": "MYT",
        "MX": "MEX",
        "FM": "FSM",
        "MD": "MDA",
        "MC": "MCO",
        "MN": "MNG",
        "ME": "MNE",
        "MS": "MSR",
        "MA": "MAR",
        "MZ": "MOZ",
        "MM": "MMR",
        "NA": "NAM",
        "NR": "NRU",
        "NP": "NPL",
        "NL": "NLD",
        "NC": "NCL",
        "NZ": "NZL",
        "NI": "NIC",
        "NE": "NER",
        "NG": "NGA",
        "NU": "NIU",
        "NF": "NFK",
        "MP": "MNP",
        "NO": "NOR",
        "OM": "OMN",
        "PK": "PAK",
        "PW": "PLW",
        "PS": "PSE",
        "PA": "PAN",
        "PG": "PNG",
        "PY": "PRY",
        "PE": "PER",
        "PH": "PHL",
        "PN": "PCN",
        "PL": "POL",
        "PT": "PRT",
        "PR": "PRI",
        "QA": "QAT",
        "RE": "REU",
        "RO": "ROU",
        "RU": "RUS",
        "RW": "RWA",
        "BL": "BLM",
        "SH": "SHN",
        "KN": "KNA",
        "LC": "LCA",
        "MF": "MAF",
        "PM": "SPM",
        "VC": "VCT",
        "WS": "WSM",
        "SM": "SMR",
        "ST": "STP",
        "SA": "SAU",
        "ZA": "SAF",
        "SN": "SEN",
        "RS": "SRB",
        "SC": "SYC",
        "SL": "SLE",
        "SG": "SGP",
        "SX": "SXM",
        "SK": "SVK",
        "SI": "SVN",
        "SB": "SLB",
        "SO": "SOM",
        "GS": "SGS",
        "SS": "SSD",
        "ES": "ESP",
        "LK": "LKA",
        "SD": "SDN",
        "SR": "SUR",
        "SJ": "SJM",
        "SE": "SWE",
        "CH": "CHE",
        "SY": "SYR",
        "TW": "TWN",
        "TJ": "TJK",
        "TZ": "TZA",
        "TH": "THA",
        "TL": "TLS",
        "TG": "TGO",
        "TK": "TKL",
        "TO": "TON",
        "TT": "TTO",
        "TN": "TUN",
        "TR": "TUR",
        "TM": "TKM",
        "TC": "TCA",
        "TV": "TUV",
        "UG": "UGA",
        "UA": "UKR",
        "AE": "ARE",
        "GB": "GBR",
        "US": "USA",
        "UM": "UMI",
        "UY": "URY",
        "UZ": "UZB",
        "VU": "VUT",
        "VE": "VEN",
        "VN": "VNM",
        "VG": "VGB",
        "VI": "VIR",
        "WF": "WLF",
        "EH": "ESH",
        "YE": "YEM",
        "ZM": "ZMB",
        "ZW": "ZWE"
    ]

}

private extension Dictionary where Value: Equatable {

    func key(forValue value: Value) -> Key? {
        first { $0.1 == value }?.0
    }

}
