const fs = require('fs');
const https = require('https');

const cfg = JSON.parse(fs.readFileSync('config_prem.json', 'utf8'));
const cookie = "cf_clearance=; session=";

fetch('https://amprem.irfanjawa.com/api/user', {
    method: 'GET',
    headers: {
        'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/124.0.0.0 Safari/537.36',
        'Accept': 'application/json, text/plain, */*',
        'Cookie': cookie
    }
}).then(res => {
    console.log('Status:', res.status);
    return res.text();
}).then(text => {
    console.log('Body:', text.substring(0, 200));
}).catch(console.error);
