#!/usr/bin/env node

const fs = require('fs');
const path = require('path');
const os = require('os');

const src = path.join(__dirname, '..', '.claude', 'skills', 'prospector', 'SKILL.md');
const dest = path.join(os.homedir(), '.claude', 'skills', 'prospector');

fs.mkdirSync(dest, { recursive: true });
fs.copyFileSync(src, path.join(dest, 'SKILL.md'));

console.log(`✅ Skill Prospector installé dans ${dest}`);
console.log('→ Lancer /prospector dans Claude Code pour démarrer la configuration.');
