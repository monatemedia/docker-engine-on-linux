// modules/wordpress/transform-components/transform-components.js
// RequiredBy: modules/wordpress/transform-components.sh
// Menu: WordPress
// Description: Transform Vite TSX components into TailPress-compatible PHP template parts
import fs from 'fs-extra';
import path from 'path';

const themeSlug = process.env.THEME_SLUG || 'default-theme';

// Updated srcDir to point to /var/www/html/template/src/components/
// path.resolve() will use the Docker container's current working directory for relative paths.
// Assuming the node script is executed from a context where the working directory is /var/www/html,
// 'template/src/components' will correctly resolve to '/var/www/html/template/src/components'.
const srcDir = path.resolve('template/src/components'); 

// destDir remains the theme's template-parts directory
const destDir = path.resolve(`wp-content/themes/${themeSlug}/template-parts`);

async function transformComponents() {
  // Ensure the destination directory exists (good practice)
  await fs.ensureDir(destDir);
  console.log(`ℹ️ Source directory for TSX components: ${srcDir}`);
  console.log(`ℹ️ Destination directory for PHP template parts: ${destDir}`);

  try {
    // Check if source directory exists
    const srcDirExists = await fs.pathExists(srcDir);
    if (!srcDirExists) {
      console.error(`❌ Source directory ${srcDir} does not exist. Cannot find components to transform.`);
      console.log(`   Based on your input, components should be in '/var/www/html/template/src/components/' inside the container.`);
      process.exit(1); // Exit if source directory is not found
    }

    const files = await fs.readdir(srcDir);
    if (files.length === 0) {
      console.log(`ℹ️ No files found in ${srcDir}. Nothing to transform.`);
      return;
    }

    let transformedCount = 0;
    for (const file of files) {
      // The provided 'ls' output shows .tsx files (e.g., About.tsx, Contact.tsx)
      if (file.endsWith('.tsx')) { 
        console.log(`⏳ Transforming ${file}...`);
        // const content = await fs.readFile(path.join(srcDir, file), 'utf8'); // Original file content, not used in this placeholder example
        const newFilename = file.replace(/\.tsx$/, '.php'); // Replace .tsx with .php
        
        // This is a placeholder for your actual transformation logic.
        // You'll need to replace this with code that converts TSX to meaningful PHP.
        const phpContent = `<?php
// WordPress Template Part
// Source File: ${file}
// Original Location: ${path.join(srcDir, file)}

/**
 * Placeholder for the transformed content of ${file}.
 * * YOU MUST REPLACE THIS WITH YOUR ACTUAL TRANSFORMATION LOGIC.
 * This logic needs to convert the TSX component's structure, styles (if any),
 * and functionality into PHP that can be rendered by WordPress.
 * * This might involve:
 * - Echoing HTML markup that mirrors the TSX component's output.
 * - Implementing any dynamic parts with PHP variables or WordPress functions.
 * - If the component fetches data, replicating that data fetching in PHP (e.g., using WP_Query or REST API calls).
 * - Integrating with WordPress hooks (actions, filters) or template tags.
 * - Handling props if your TSX components expect them (e.g., by passing data via set_query_var or function arguments).
 */

echo "<div class='component-placeholder transformed-component component-${path.basename(newFilename, '.php')}'>";
echo "  <h2>PHP Template Part: ${path.basename(newFilename, '.php')} (from ${file})</h2>";
echo "  <p>This is a basic PHP template part transformed from the TSX component: <strong>${file}</strong>.</p>";
echo "  <p><strong>Important:</strong> Implement the actual rendering logic derived from the TSX component here.</p>";
echo "</div>";

?>`;
        const outputPath = path.join(destDir, newFilename);
        await fs.outputFile(outputPath, phpContent); // fs.outputFile creates directory if it doesn't exist
        transformedCount++;
        console.log(`✅ Transformed ${file} to ${newFilename} and saved in ${destDir}`);
      } else {
        // If you have other file types (e.g., .css, .svg) in the components folder that don't need transformation
        console.log(`ℹ️ Skipping file (not a .tsx): ${file} in ${srcDir}.`);
      }
    }

    if (transformedCount > 0) {
      console.log(`🎉 Successfully transformed ${transformedCount} .tsx files to PHP template parts in ${destDir}.`);
    } else {
      console.log(`ℹ️ No .tsx files were found or transformed in ${srcDir}. Ensure your files have a .tsx extension.`);
    }

  } catch (err) {
    // Catch errors that might occur during the file system operations or other parts of the try block
    if (err.code === 'ENOENT' && err.path === srcDir) { 
        // This specific check might be redundant due to the srcDirExists check, but it's a good fallback.
        console.error(`❌ Error: Source directory ${srcDir} was not found during 'readdir' operation.`);
    } else {
        console.error(`❌ Error during component transformation:`, err);
    }
    process.exit(1); // Exit with an error code
  }
}

// Execute the main function and catch any unhandled promise rejections
transformComponents().catch((err) => {
  console.error('❌ An unexpected error occurred that prevented the transformation script from running correctly:', err);
  process.exit(1);
});