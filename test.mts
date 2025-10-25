import { dir } from 'node:console';
import * as fs from 'node:fs';
import * as path from 'node:path';
import * as process from 'node:process';
import * as child_process from 'node:child_process';
let files = fs.readdirSync(".", { withFileTypes: true });

let dirs = files.filter(f => f.isDirectory()).map(d => d.name);


let moonbit_modules = dirs.filter(d => {
    let files = fs.readdirSync(d)
    return files.includes("moon.mod.json")
})

for (let module of moonbit_modules) {
    process.chdir(module);
    console.log(`===== Testing module: ${module} =====`);
    let log = child_process.execSync("moon test")
    console.log(log.toString());
    process.chdir("..");
}
