function handler(event) {
    var response = event.response;
    var headers = response.headers;

    // efficient cache policy
    headers['cache-control'] = { value: 'public, max-age=63072000;' };

    // prevents MITM from downgrading the transport security between them and the client
    headers['strict-transport-security'] = { value: 'max-age=63072000; includeSubdomains; preload' };

    /* HTTP security headers only relevant if the site contains user generated content
    headers['content-security-policy'] = { value: "default-src 'none'; img-src 'self'; script-src 'self'; style-src 'self'; object-src 'none'"}; 
    headers['x-xss-protection'] = {value: '1; mode=block'};
    headers['x-content-type-options'] = { value: 'nosniff' };
    */

    /* HTTP security headers only relevant if there are authenticated users in the site
    headers['x-frame-options'] = {value: 'DENY'};
    */

    // Return response to viewers
    return response;
}