// modules/wordpress/transform-components/transform-components.js
// RequiredBy: modules/wordpress/transform-components.sh
// Menu: WordPress
// Description: Transform Vite JSX/TSX components into TailPress-compatible PHP template parts

const fs = require('fs-extra');
const path = require('path');
const prettier = require('prettier');

// Paths
const COMPONENTS_DIR = '/var/www/html/template/src/components';
const THEME_PARTS_DIR = '/var/www/html/wp-content/themes';
const THEME_SLUG = process.env.THEME_SLUG;
const OUTPUT_DIR = path.join(THEME_PARTS_DIR, THEME_SLUG, 'template-parts');

// Transform logic
async function transformComponent(filePath, outputPath) {
  const name = path.basename(filePath, path.extname(filePath));
  let contents = await fs.readFile(filePath, 'utf-8');

  // Remove import/export lines
  contents = contents
    .replace(/import[^;]+;/g, '')
    .replace(/export default [a-zA-Z0-9_]+;/g, '')
    .replace(/export\s+(function|const|default)[^{]*{/, '')
    .trim();

  const htmlMatch = contents.match(/return\s*\(([\s\S]*?)\);?/);
  const html = htmlMatch ? htmlMatch[1].trim() : '<!-- could not parse JSX -->';

  const phpTemplate = `<?php // Template part: ${name} ?>
<!-- Start ${name} -->
${html}
<!-- End ${name} -->
`;

  const formatted = prettier.format(phpTemplate, { parser: 'html' });
  await fs.outputFile(outputPath, formatted);
  console.log(`✅ Transformed: ${name}`);
}

// Run for all components
(async () => {
  const files = await fs.readdir(COMPONENTS_DIR);
  await fs.ensureDir(OUTPUT_DIR);

  for (const file of files) {
    if (file.endsWith('.tsx')) {
      const inputPath = path.join(COMPONENTS_DIR, file);
      const outputPath = path.join(OUTPUT_DIR, `${path.basename(file, '.tsx').toLowerCase()}.php`);
      await transformComponent(inputPath, outputPath);
    }
  }

  console.log('🚀 All components transformed!');
})();
