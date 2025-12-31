#!/usr/bin/env node

/**
 * Validates marketplace.json against schema and best practices
 */

const fs = require('fs');
const path = require('path');

const MARKETPLACE_PATH = path.join(__dirname, '../.claude-plugin/marketplace.json');

// ANSI color codes
const colors = {
  red: '\x1b[31m',
  green: '\x1b[32m',
  yellow: '\x1b[33m',
  blue: '\x1b[34m',
  reset: '\x1b[0m',
};

const errors = [];
const warnings = [];

function error(msg) {
  errors.push(msg);
  console.error(`${colors.red}✗${colors.reset} ${msg}`);
}

function warn(msg) {
  warnings.push(msg);
  console.warn(`${colors.yellow}⚠${colors.reset} ${msg}`);
}

function success(msg) {
  console.log(`${colors.green}✓${colors.reset} ${msg}`);
}

function info(msg) {
  console.log(`${colors.blue}ℹ${colors.reset} ${msg}`);
}

// Load marketplace.json
let marketplace;
try {
  const content = fs.readFileSync(MARKETPLACE_PATH, 'utf8');
  marketplace = JSON.parse(content);
  success('marketplace.json is valid JSON');
} catch (err) {
  error(`Failed to parse marketplace.json: ${err.message}`);
  process.exit(1);
}

// Validate root-level fields
console.log('\n' + colors.blue + 'Validating marketplace metadata...' + colors.reset);

if (!marketplace.name || typeof marketplace.name !== 'string') {
  error('Missing or invalid "name" field (must be string)');
} else if (!/^[a-z0-9-]+$/.test(marketplace.name)) {
  error('Marketplace "name" must be kebab-case (lowercase, hyphens only)');
} else {
  success(`Marketplace name: ${marketplace.name}`);
}

// Reserved names check
const reservedNames = [
  'claude-code-marketplace',
  'anthropic-plugins',
  'anthropic-marketplace',
  'agent-skills',
  'official',
  'anthropic'
];

if (reservedNames.includes(marketplace.name)) {
  error(`Marketplace name "${marketplace.name}" is reserved and cannot be used`);
}

if (!marketplace.owner || typeof marketplace.owner !== 'object') {
  error('Missing or invalid "owner" field (must be object with name)');
} else {
  if (!marketplace.owner.name) {
    error('Missing "owner.name"');
  } else {
    success(`Owner: ${marketplace.owner.name}`);
  }
  if (!marketplace.owner.email) {
    warn('Missing "owner.email" (recommended)');
  }
}

if (marketplace.description) {
  if (marketplace.description.length > 300) {
    warn('Marketplace description is quite long (> 300 chars)');
  } else {
    success('Description present');
  }
}

if (!marketplace.plugins || !Array.isArray(marketplace.plugins)) {
  error('Missing or invalid "plugins" array');
  process.exit(1);
}

// Validate plugins
console.log('\n' + colors.blue + `Validating ${marketplace.plugins.length} plugin(s)...` + colors.reset);

const pluginNames = new Set();

marketplace.plugins.forEach((plugin, index) => {
  console.log(`\n${colors.blue}Plugin ${index + 1}:${colors.reset} ${plugin.name || '(unnamed)'}`);

  // Required fields
  if (!plugin.name) {
    error(`  Plugin ${index + 1}: Missing "name"`);
  } else if (!/^[a-z0-9-]+$/.test(plugin.name)) {
    error(`  Plugin "${plugin.name}": Name must be kebab-case`);
  } else if (pluginNames.has(plugin.name)) {
    error(`  Plugin "${plugin.name}": Duplicate name`);
  } else {
    pluginNames.add(plugin.name);
    success(`  Name: ${plugin.name}`);
  }

  if (!plugin.source) {
    error(`  Plugin "${plugin.name}": Missing "source"`);
  } else {
    if (typeof plugin.source === 'string') {
      success(`  Source: ${plugin.source}`);
    } else if (typeof plugin.source === 'object') {
      if (plugin.source.source === 'github' && plugin.source.repo) {
        success(`  Source: GitHub (${plugin.source.repo})`);
      } else if (plugin.source.source === 'url' && plugin.source.url) {
        success(`  Source: URL (${plugin.source.url})`);
      } else {
        error(`  Plugin "${plugin.name}": Invalid source object`);
      }
    } else {
      error(`  Plugin "${plugin.name}": source must be string or object`);
    }
  }

  // Recommended fields
  if (!plugin.description) {
    warn(`  Plugin "${plugin.name}": Missing description (recommended)`);
  } else if (plugin.description.length > 200) {
    warn(`  Plugin "${plugin.name}": Description is long (> 200 chars)`);
  } else {
    success(`  Description: "${plugin.description.substring(0, 50)}..."`);
  }

  if (!plugin.version) {
    warn(`  Plugin "${plugin.name}": Missing version (recommended)`);
  } else if (!/^\d+\.\d+\.\d+/.test(plugin.version)) {
    warn(`  Plugin "${plugin.name}": Version should follow semver (x.y.z)`);
  } else {
    success(`  Version: ${plugin.version}`);
  }

  if (!plugin.author) {
    warn(`  Plugin "${plugin.name}": Missing author (recommended)`);
  } else if (typeof plugin.author === 'object') {
    if (!plugin.author.name) {
      warn(`  Plugin "${plugin.name}": Missing author.name`);
    } else {
      success(`  Author: ${plugin.author.name}`);
    }
  } else if (typeof plugin.author === 'string') {
    success(`  Author: ${plugin.author}`);
  }

  if (!plugin.license) {
    warn(`  Plugin "${plugin.name}": Missing license (recommended: MIT or Apache-2.0)`);
  } else {
    success(`  License: ${plugin.license}`);
  }

  if (!plugin.keywords || plugin.keywords.length === 0) {
    warn(`  Plugin "${plugin.name}": No keywords (recommended for searchability)`);
  } else if (plugin.keywords.length < 3) {
    warn(`  Plugin "${plugin.name}": Consider adding more keywords (3-7 recommended)`);
  } else {
    success(`  Keywords: ${plugin.keywords.join(', ')}`);
  }

  if (!plugin.category) {
    warn(`  Plugin "${plugin.name}": Missing category (helps with discovery)`);
  } else {
    const validCategories = [
      'productivity',
      'code-quality',
      'testing',
      'documentation',
      'devops',
      'security',
      'data'
    ];
    if (!validCategories.includes(plugin.category)) {
      warn(`  Plugin "${plugin.name}": Unknown category "${plugin.category}"`);
    } else {
      success(`  Category: ${plugin.category}`);
    }
  }

  // Optional but good to have
  if (!plugin.homepage && !plugin.repository) {
    warn(`  Plugin "${plugin.name}": No homepage or repository URL (recommended)`);
  }

  // Validate optional fields format
  if (plugin.homepage && !isValidUrl(plugin.homepage)) {
    warn(`  Plugin "${plugin.name}": homepage is not a valid URL`);
  }

  if (plugin.repository && !isValidUrl(plugin.repository)) {
    warn(`  Plugin "${plugin.name}": repository is not a valid URL`);
  }
});

// Summary
console.log('\n' + colors.blue + '═'.repeat(60) + colors.reset);
console.log(colors.blue + 'Validation Summary' + colors.reset);
console.log(colors.blue + '═'.repeat(60) + colors.reset);

if (errors.length === 0 && warnings.length === 0) {
  console.log(colors.green + '✓ All checks passed!' + colors.reset);
  console.log(`  ${marketplace.plugins.length} plugin(s) validated successfully`);
  process.exit(0);
} else {
  if (errors.length > 0) {
    console.log(`${colors.red}✗ ${errors.length} error(s)${colors.reset}`);
    process.exit(1);
  }
  if (warnings.length > 0) {
    console.log(`${colors.yellow}⚠ ${warnings.length} warning(s)${colors.reset}`);
    console.log('  Warnings do not prevent validation but should be addressed');
  }
  console.log(`${colors.green}✓ ${marketplace.plugins.length} plugin(s) validated${colors.reset}`);
  process.exit(0);
}

// Helper functions
function isValidUrl(string) {
  try {
    new URL(string);
    return true;
  } catch (_) {
    return false;
  }
}
