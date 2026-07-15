const readline = require('readline');
const http = require('http');
const https = require('https');

// GANTI DENGAN URL RAILWAY LU! 
const SERVER_URL = 'https://motionhubapi.lanncodex.biz.id';

const rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout
});

const C = { reset: "\x1b[0m", cyan: "\x1b[36m", green: "\x1b[32m", yellow: "\x1b[33m", red: "\x1b[91m" };

async function apiRequest(endpoint, body) {
    const isHttps = SERVER_URL.startsWith('https');
    const lib = isHttps ? https : http;
    const url = new URL(SERVER_URL + endpoint);
    
    const data = JSON.stringify(body);
    const options = {
        method: 'POST',
        headers: { 'Content-Type': 'application/json', 'Content-Length': Buffer.byteLength(data) }
    };

    return new Promise((resolve, reject) => {
        const req = lib.request(url, options, (res) => {
            let resData = '';
            res.on('data', chunk => resData += chunk);
            res.on('end', () => {
                try { resolve(JSON.parse(resData)); } 
                catch(e) { resolve({ error: resData }); }
            });
        });
        req.on('error', reject);
        req.write(data);
        req.end();
    });
}

function showMenu() {
    console.log(`\n${C.cyan}╔═══════════════════════════════════════════════════════════╗${C.reset}`);
    console.log(`${C.cyan}║             🚀 AM GENERATOR TERMUX CLIENT                 ║${C.reset}`);
    console.log(`${C.cyan}╚═══════════════════════════════════════════════════════════╝${C.reset}`);
    console.log(`Server Target: ${C.yellow}${SERVER_URL}${C.reset}\n`);
    console.log(`[1] Tembak Akun Baru (Kirim Email & Tempel Magic Link)`);
    console.log(`[2] Tembak Akun Terverifikasi (Klaim VIP Langsung)`);
    console.log(`[0] Keluar\n`);

    rl.question(`👉 Pilih Menu [1/2/0]: `, async (choice) => {
        if (choice === '1') {
            rl.question('\n📧 Masukkan Email target: ', async (email) => {
                console.log(`${C.yellow}⏳ Mengirim request ke server...${C.reset}`);
                const sendRes = await apiRequest('/api/send', { email });
                console.log(`Hasil:`, sendRes);
                
                rl.question('\n🔗 Paste Magic Link dari Gmail: ', async (magicLink) => {
                    console.log(`${C.yellow}⏳ Memproses verifikasi di server...${C.reset}`);
                    const verifRes = await apiRequest('/api/verify', { email, magicLink });
                    console.log(`Hasil:`, verifRes);
                    showMenu();
                });
            });
        } else if (choice === '2') {
            rl.question('\n📧 Masukkan Email terverifikasi: ', async (email) => {
                console.log(`${C.yellow}⏳ Memproses bypass & apply VIP...${C.reset}`);
                const claimRes = await apiRequest('/api/claim', { email });
                console.log(`Hasil:`, claimRes);
                showMenu();
            });
        } else {
            console.log("Keluar...");
            process.exit(0);
        }
    });
}

showMenu();
