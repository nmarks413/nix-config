#!/usr/bin/env node
// autofmt v1 by paper clover
// https://paperclover.dev/nix/config/src/branch/main/packages/autofmt/autofmt.js
//
// Different codebases use different formatters. Autofmt looks for project
// configuration to pick the correct formatter, allowing an editor to simply
// point to this script and ambiguities resolved. This single file program
// depends only on Node.js v22.
//
// When using this repository's Nix-based Neovim configuration, autofmt is
// automatically configured as the default formatter. To configure manually,
// set the editor's formatter to run `autofmt --stdio=<filename>`. The filename
// is used to determine which formatter to invoke.
//
// With `conform.nvim`:
//   formatters = {
//     autofmt = { command = "autofmt" }
//   }
//
// With Zed:
//   "formatter": {
//     "external": {
//       "command": "autofmt",
//       "arguments": ["--stdio", "{buffer_path}"]
//     }
//   },
//
// @ts-nocheck

// -- definitions --
const extensions = {
  c: [".c", ".h"],
  cpp: [".cpp", ".cc", ".cxx", ".hpp", ".hxx", ".hh"],
  css: [".css"],
  html: [".html"],
  javascript: [".js", ".ts", ".cjs", ".cts", ".mjs", ".mts", ".jsx", ".tsx"],
  json: [".json", ".jsonc"],
  markdown: [".md", ".markdown"],
  mdx: [".mdx"],
  nix: [".nix"],
  rust: [".rs"],
  toml: [".toml"],
  yaml: [".yml", ".yaml"],
  zig: [".zig"],
};
const formatters = {
  // this object is sorted by priority
  //
  // `languages: true` are multiplexers that apply to all listed
  // languages, as it is assumed a project will setup their multiplexer
  // correctly for all tracked files.
  //
  // if a formatter doesnt match a config file, the first one is picked
  // as a default, making things like `deno fmt file.ts` or `clang-format`
  // the default when there are no config files.
  dprint: {
    languages: true,
    files: ["dprint.json", "dprint.jsonc"],
    cmd: ["dprint", "fmt", "--", "$files"],
    stdin: (file) => ["dprint", "fmt", "--stdin", file],
  },
  treefmt: {
    languages: true,
    files: ["treefmt.toml", ".treefmt.toml"],
    cmd: ["treefmt", "--", "$files"],
    stdin: (file) => ["treefmt", "--stdin", file],
  },
  // -- web ecosystem --
  deno: {
    languages: ["javascript", "markdown", "json", "yaml", "html", "css"],
    files: ["dprint.json", "dprint.jsonc"],
    cmd: ["deno", "fmt", "--", "$files"],
    stdin: (file) => ["deno", "fmt", "--ext", path.extname(file).slice(1), "-"],
  },
  prettier: {
    languages: ["javascript", "markdown", "json", "yaml", "mdx", "html", "css"],
    files: ["node_modules/.bin/prettier"],
    cmd: ["node_modules/.bin/prettier", "--write", "--", "$files"],
    stdin: (file) => ["node_modules/.bin/prettier", "--stdin-filepath", file],
  },
  biome: {
    languages: ["javascript", "json", "css"],
    files: ["node_modules/.bin/biome"],
    cmd: ["node_modules/.bin/biome", "format", "--", "$files"],
    stdin: (file) => [
      "node_modules/bin/biome",
      "format",
      `--stdin-file-path=${file}`,
    ],
  },
  "nixfmt-rfc-style": {
    languages: ["nix"],
    files: {
      "flake.nix": (contents) => contents.includes("nixfmt"),
    },
    cmd: ["nixfmt", "--", "$files"],
    stdin: (file) => ["nixfmt", `--filename=${file}`],
  },
  alejandra: {
    languages: ["nix"],
    files: {
      "flake.nix": (contents) => contents.includes("alejandra"),
    },
    cmd: ["alejandra", "--", "$files"],
    stdin: () => ["alejandra"],
  },
  clang: {
    languages: ["c", "cpp"],
    files: true,
    cmd: ["clang-format", "--", "$files"],
    stdin: (file) => ["clang-format", `--assume-filename=${file}`],
  },
  zig: {
    languages: ["zig"],
    files: true,
    cmd: ["zig", "fmt", "$files"],
    stdin: (file) => [
      "zig",
      "fmt",
      "--stdin",
      ...file.endsWith(".zon") ? ["--zon"] : [],
    ],
  },
  rustfmt: {
    languages: ["rust"],
    files: true,
    cmd: ["rustfmt", "--", "$files"],
    stdin: () => ["rustfmt"],
  },
  taplo: {
    languages: ["toml"],
    files: ["taplo.toml"],
    cmd: ["taplo", "format", "--", "$files"],
    cmd: () => ["taplo", "format", "-"],
  },
};

// -- cli --
if (!fs.globSync) {
  console.error(`error: autofmt must be run with Node.js v22 or newer`);
  process.exit(1);
}
const [, bin, ...argv] = process.argv;
let inputs = [];
let globalExclude = [];
let gitignore = true;
let dryRun = false;
let stdio = null;
let excludes = [".git"];
while (argv.length > 0) {
  const arg = argv.shift();
  if (arg === "-h" || arg === "--help") usage();
  else if (arg === "--no-gitignore") gitignore = false;
  else if (arg === "--dry-run") dryRun = true;
  else if (arg.match(/^--stdio=./)) {
    if (stdio) {
      console.error("error: can only pass --stdio once");
      usage();
    }
    stdio = arg.slice("--stdio=".length);
  } else if (arg === "--stdio") {
    const value = argv.shift();
    if (!value) {
      console.error("error: missing value for --stdio");
      usage();
    }
    if (stdio) {
      console.error("error: can only pass --stdio once");
      usage();
    }
    stdio = value;
  } else if (arg.match(/^--exclude=./)) {
    excludes.push(arg.slice("--exclude=".length));
  } else if (arg === "--") {
    inputs.push(...argv);
    break;
  } else if (arg.startsWith("-")) {
    console.error("error: unknown option " + JSON.stringify(arg));
    usage();
  } else inputs.push(arg);
}
function usage() {
  const exe = path.basename(bin);
  console.error(`usage: ${exe} [...files or directories]`);
  console.error(``);
  console.error(`uses the right formatter for the job (by scanning config)`);
  console.error(`when autofmt reads dirs, it will respect gitignore`);
  console.error(``);
  console.error(`to format current directory recursively, run '${exe} .'`);
  console.error(``);
  console.error(`options:`);
  console.error(`  --dry-run           print commands instead of running them`);
  console.error(`  --no-gitignore      do not read '.gitignore'`);
  console.error(`  --exclude=<glob>    add an exclusion glob`);
  console.error(`  --stdio=<filename>  read/write contents via stdin/stdout`);
  console.error(``);
  process.exit(1);
}
if (inputs.length === 0 && !stdio) usage();
if (stdio && inputs.length > 0) {
  console.error("error: stdio mode only operates on one file");
  process.exit(1);
}
const { sep } = path;

// -- disable warnings --
const { emit: originalEmit } = process;
const warnings = ["ExperimentalWarning"];
process.emit = function (event, error) {
  return event === "warning" && warnings.includes(error.name)
    ? false
    : originalEmit.apply(process, arguments);
};

// -- vars --
const extToLanguage = Object.fromEntries(
  Object.entries(extensions).flatMap(([lang, exts]) =>
    exts.map((ext) => [ext, lang])
  ),
);
const multis = Object.keys(formatters).filter(
  (x) => formatters[x].languages === true,
);
const files = [];
const gitignores = new Map();
const dirs = new Map();
const cached = new Map();

// -- stdin mode --
if (stdio) {
  const fmtWithPath = pickFormatter(stdio);
  if (!fmtWithPath) {
    console.error(`No formatter configured for ${path.relative(".", stdio)}`);
    process.exit(1);
  }
  let [fmt, cwd] = fmtWithPath.split("\0");
  let cmd = formatters[fmt].stdin(stdio);
  cwd ??= process.cwd();
  if (dryRun) {
    console.info(cmd.join(" "));
    process.exit(0);
  }
  const proc = child_process.spawn(cmd[0], cmd.slice(1), {
    stdio: ["inherit", "inherit", "inherit"],
  });
  proc.on("error", (e) => {
    let message = "";
    if (e?.code === "ENOENT") {
      message = `${cmd[0]} is not installed`;
    } else {
      message = String(e?.message ?? e);
    }
    console.error(`error: ${message}`);
    process.exit(1);
  });
  const [code] = await events.once(proc, "exit");
  process.exit(code ?? 1);
}

// -- decide what formatters to run
inputs = inputs.map((x) => path.resolve(x));
inputs.forEach(walk);
const toRun = new Map();
for (const file of new Set(files)) {
  const fmt = pickFormatter(file);
  if (!fmt) {
    if (inputs.includes(file)) {
      console.warn(`No formatter configured for ${path.relative(".", file)}`);
    }
    continue;
  }
  let list = toRun.get(fmt);
  list ?? toRun.set(fmt, list = []);
  list.push(file);
}

// -- create a list of commands --
const commands = [];
let totalFiles = 0;
for (const [fmtWithPath, files] of toRun) {
  let [fmt, cwd] = fmtWithPath.split("\0");
  let { cmd } = formatters[fmt];
  if (cwd) cmd = [path.join(cwd, cmd[0]), ...cmd.slice(1)];
  cwd ??= process.cwd();
  let i = 0;
  totalFiles += files.length;
  if ((i = cmd.indexOf("$files")) != -1) {
    const c = cmd.slice();
    c.splice(i, 1, ...files);
    commands.push({ cmd: c, cwd, files });
  } else if ((i = cmd.indexOf("$file")) != -1) {
    for (const file of files) {
      const c = cmd.slice();
      c.splice(i, 1, file);
      commands.push({ cmd: c, cwd, files: [file] });
    }
  } else {
    throw new Error(`Formatter ${fmt} has incorrectly configured command.`);
  }
}
if (commands.length === 0) {
  console.error("No formattable files");
  process.exit(0);
}

// -- dry run mode --
if (dryRun) {
  for (const { cmd } of commands) {
    console.info(cmd);
  }
  process.exit(0);
}

// -- user interface --
let filesComplete = 0;
let lastFile = commands[0].cmd;
const syncStart = "\u001B[?2026h";
const syncEnd = "\u001B[?2026l";
let buffer = "";
let statusVisible = false;
const tty = process.stderr.isTTY;
function writeStatus() {
  if (!tty) return;
  clearStatus();
  buffer ||= syncStart;
  buffer += `${filesComplete}/${totalFiles} - ${lastFile}`;
  statusVisible = true;
}
function clearStatus() {
  if (!tty) return;
  if (!statusVisible) return;
  buffer ||= syncStart;
  buffer += "\r\x1b[2K\r";
  statusVisible = false;
}
function flush() {
  if (!buffer) return;
  const width = Math.max(1, process.stderr.columns - 1);
  process.stderr.write(
    buffer.split("\n").map((x) => x.slice(0, width)).join("\n") + syncEnd,
  );
  buffer = "";
}

// -- async process queue --
let running = 0;
/** @param cmd {{ cmd: string, cwd: string, files: string[] }} */
function run({ cmd, cwd, files }) {
  running += 1;
  let c = child_process.spawn(cmd[0], cmd.slice(1), {
    stdio: ["ignore", "pipe", "pipe"],
    cwd,
  });
  const relatives = new Set(
    files.map((file) => file.startsWith(cwd) ? path.relative(cwd, file) : file),
  );
  function onLine(line) {
    for (const file of relatives) {
      if (line.includes(file)) {
        filesComplete += 1;
        relatives.delete(file);
        lastFile = path.relative(process.cwd(), path.resolve(cwd, file));
        if (tty) {
          writeStatus();
          flush();
        } else {
          console.info(lastFile);
        }
        return;
      }
    }
  }
  let errBuffer = "";
  let exited = false;
  c.on("error", (e) => {
    let message = "";
    if (e?.code === "ENOENT") {
      if (cmd[0].includes("/")) {
        running -= 1;
        run({ cmd: [path.basename(cmd[0]), ...cmd.slice(1)], cwd, files });
        return;
      }
      message = `${cmd[0]} is not installed`;
    } else {
      message = String(e?.message ?? e);
    }
    clearStatus();
    const filesConcise =
      path.relative(".", path.resolve(cwd, relatives.keys().next().value)) + (
        relatives.size > 1 ? ` and ${relatives.size - 1} more` : ""
      );
    buffer += errBuffer + `error: ${message}, cannot format ${filesConcise}.\n`;
    flush();
    exited = true;
    runNext();
  });
  readline.createInterface(c.stderr).addListener("line", (line) => {
    errBuffer += line + "\n";
    onLine(line);
  });
  readline.createInterface(c.stdout).addListener("line", onLine);
  c.on("exit", (code, signal) => {
    if (exited) return;
    exited = true;
    if (code !== 0) {
      clearStatus();
      const exitStatus = code != null ? `code ${code}` : `signal ${signal}`;
      buffer += errBuffer + `error: ${cmd[0]} exited with ${exitStatus}\n`;
      flush();
    } else {
      filesComplete += relatives.size;
      if (relatives.size) {
        lastFile = path.relative(
          ".",
          path.resolve(cwd, relatives.keys().next().value),
        );
      }
      writeStatus();
      flush();
    }
    runNext();
  });
  function runNext() {
    running -= 1;
    const next = commands.pop();
    if (next) run(next);
    else if (running == 0) {
      clearStatus();
      flush();
      console.info(
        `Formatted ${filesComplete} file${filesComplete !== 1 ? "s" : ""}`,
      );
    }
  }
}

for (let i = 0; i < navigator.hardwareConcurrency; i++) {
  const cmd = commands.pop();
  if (cmd) run(cmd);
  else break;
}

// -- library functions --

/** @param file {string} */
function walk(file) {
  file = path.resolve(file);
  try {
    if (fs.statSync(file).isDirectory()) {
      const exclude = getGitIgnores(file);
      const read = fs
        .globSync(escapeGlob(file) + "/{**,.**}", {
          exclude,
          withFileTypes: true,
        })
        .filter((file) => !file.isDirectory())
        .map((file) => path.join(file.parentPath, file.name));
      files.push(...read);
    } else {
      files.push(file);
    }
  } catch (err) {
    console.error(
      `Failed to stat ${file}: ${err?.code ?? err?.message ?? err}`,
    );
    process.exit(1);
  }
}

/** @param dir {string} @returns {Array<string>} */
function readDir(dir) {
  dir = path.resolve(dir);
  let contents = dirs.get(dir);
  if (!contents) {
    try {
      contents = fs.readdirSync(dir);
    } catch {
      contents = [];
    }
    dirs.set(dir, contents);
  }
  return contents;
}

/** @param dir {string} @returns {string} */
function pickFormatter(file) {
  const lang = extToLanguage[path.extname(file)];
  const dir = path.dirname(file);
  let c = walkUp(dir, (x) => cached.get(x) ?? cached.get(`${x}:${lang}`));
  if (c) return c;

  const possible = Object.keys(formatters).filter(
    (x) =>
      Array.isArray(formatters[x].languages) &&
      formatters[x].languages.includes(lang),
  );
  const order = [...multis, ...possible];
  return walkUp(dir, (x) => {
    const children = readDir(x);
    for (const fmt of order) {
      let matches = false;
      if (formatters[fmt].files === true) {
        matches = true;
      }
      if (!matches) {
        const filesToCheck = Array.isArray(formatters[fmt].files)
          ? formatters[fmt].files.map((base) => ({ base, contents: true }))
          : Object.entries(formatters[fmt].files)
            .map(([base, contents]) => ({ base, contents }));
        for (const { base, contents } of filesToCheck) {
          if (base.includes("/")) {
            matches = readDir(path.join(x, path.dirname(base))) //
              .includes(path.basename(base));
          } else {
            matches = children.includes(base);
          }
          if (matches && typeof contents === "function") {
            matches = !!contents(fs.readFileSync(path.join(x, base), "utf-8"));
          }
        }
      }
      if (matches) {
        const formatterId = `${fmt}\0${x}`;
        const k = multis.includes(fmt) ? x : `${x}:${lang}`;
        cached.set(k, formatterId);
        return formatterId;
      }
    }
  }) ?? possible[0];
}

/** @param dir {string} @param find {(x: string) => any} */
function walkUp(dir, find) {
  do {
    const found = find(dir);
    if (found != null) return found;
    const parent = path.dirname(dir);
    if (parent === dir) break;
    dir = parent;
  } while (true);
  return null;
}

/** @param dir {string} */
function getGitIgnores(dir) {
  if (!gitignore) return [];
  if (dir.endsWith(sep)) dir = dir.slice(0, -1);
  const files = fs.globSync(`${dir}${sep}{**${sep}*${sep},}.gitignore`, {});
  const referenced = [];
  for (const abs of files) {
    const dir = path.dirname(abs);
    referenced.push(dir);
    if (!gitignores.has(dir)) gitignores.set(dir, readGitIgnore(dir));
  }
  do {
    const parent = path.dirname(dir);
    if (parent === dir || fs.existsSync(path.join(dir, ".git"))) break;
    referenced.push(parent);
    if (!gitignores.has(parent)) gitignores.set(parent, readGitIgnore(parent));
    dir = parent;
  } while (true);
  return referenced.flatMap((root) =>
    (gitignores.get(root) ?? [])
      .filter((x) => x[0] !== "!")
      .map(
        (rule) => `${root}${sep}${rule[0] === "/" ? "" : `**${sep}`}${rule}`,
      )
  );
}

/** @param dir {string} */
function readGitIgnore(dir) {
  try {
    return fs
      .readFileSync(`${dir}${sep}.gitignore`, "utf-8")
      .split("\n")
      .map((line) => line.replace(/#.*$/, "").trim())
      .filter(Boolean);
  } catch {
    return [];
  }
}

function escapeGlob(str) {
  return str.replace(/[\\*,{}]/g, "\\$&");
}

import * as child_process from "node:child_process";
import * as fs from "node:fs";
import * as path from "node:path";
import * as readline from "node:readline";
import * as events from "node:events";
import process from "node:process";
import assert from "node:assert";
