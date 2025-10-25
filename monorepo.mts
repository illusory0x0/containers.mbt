import { dir } from 'node:console';
import * as fs from 'node:fs';
import * as path from 'node:path';
import * as process from 'node:process';
import * as child_process from 'node:child_process';
import { promisify } from 'node:util';

const execAsync = promisify(child_process.exec);

let files = fs.readdirSync(".", { withFileTypes: true });

let dirs = files.filter(f => f.isDirectory()).map(d => d.name);


let moonbit_modules = dirs.filter(d => {
    let files = fs.readdirSync(d)
    return files.includes("moon.mod.json")
})

let promises = []

for (let module of moonbit_modules) {
    let args = process.argv.slice(2).join(" ");
    let promise = execAsync(`moon ${args}`, { cwd: module });
    promises.push(promise);
}

Promise.all(promises).then((results) => {
    for (let result of results) {
        process.stdout.write(result.stdout);
        process.stderr.write(result.stderr);
    }
}).catch((error) => {
    process.stdout.write(error.stdout);
    process.stderr.write(error.stderr);
    process.exit(1);
});
