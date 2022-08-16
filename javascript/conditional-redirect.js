var americanCountriesAndTerritories = [
    "AG", // Antigua and Barbuda
    "AI", // Anguilla
    "AR", // Argentina
    "AW", // Aruba
    "BB", // Barbados
    "BM", // Bermuda
    "BO", // Bolivia
    "BQ", // Bonaire, Sint Eustatius and Saba
    "BR", // Brazil
    "BS", // Bahamas
    "BZ", // Belize
    "CA", // Canada
    "CL", // Chile
    "CO", // Colombia
    "CR", // Costa Rica
    "CU", // Cuba
    "CW", // Curaçao
    "DM", // Dominica
    "DO", // Dominican Republic
    "EC", // Ecuador
    "FK", // Falkland Islands
    "GD", // Grenada
    "GF", // French Guiana
    "GL", // Greenland
    "GP", // Guadeloupe
    "GT", // Guatemala
    "GY", // Guyana
    "HN", // Honduras
    "HT", // Haiti
    "JM", // Jamaica
    "KN", // Saint Kitts and Nevis
    "KY", // Cayman Islands
    "LC", // Saint Lucia
    "MQ", // Martinique
    "MS", // Montserrat
    "MX", // Mexico
    "NI", // Nicaragua
    "PA", // Panama
    "PE", // Peru
    "PR", // Puerto Rico
    "PY", // Paraguay
    "SR", // Suriname
    "SV", // El Salvador
    "SX", // Sint Maarten
    "TC", // Turks and Caicos Islands
    "TT", // Trinidad and Tobago
    "US", // United States
    "UY", // Uruguay
    "VC", // Saint Vincent and the Grenadines
    "VE", // Venezuela
    "VG", // British Virgin Islands
    "VI", // U.S. Virgin Islands
];

function handler(event) {
    var request = event.request;
    var headers = request.headers;
    var cloudfrontViewerCountry = headers['cloudfront-viewer-country'];
    if (americanCountriesAndTerritories.includes(cloudfrontViewerCountry)) {
        return request;
    }

    var uri = request.uri;
    if (request.uri.endsWith("/")) {
        uri += "index.html";
    }

    var response = {
        statusCode: 302,
        statusDescription: 'Found',
        headers:
            { "location": { "value": "/east" + uri } }
    }

    return response;
}
