// ROI Saver Macro - User Manual
// ----------------------------

// Overview
// The ROI Saver Macro allows quick saving of selected regions as TIF files 
// with automatic numbering and ROI Manager integration.

// Installation
// 1. Place this .ijm file in ImageJ/Fiji's plugins folder or subfolder
// 2. Restart ImageJ/Fiji to auto-install, or use Plugins > Macros > Install...
// 3. Tool icon will appear in toolbar after installation

// Initialization
// - Click "Init" button in toolbar OR press "i" key
// - Select output directory when prompted

// Usage
// 1. Open target image
// 2. Create selection using any tool (rectangle, oval, etc.)
// 3. Press Alt+A to:
//    - Save ROI as "cell_N.tif" (N = existing TIF count + 1)
//    - Add ROI to ROI Manager as "cell_N"
//    - Display confirmation in log window

// Features
// - Automatic continuous numbering based on existing TIF files
// - Auto-opens ROI Manager if closed
// - Works with all selection types
// - Status messages in log window

// Troubleshooting
// - "No ROI selected" error: Ensure active selection before Alt+A
// - "No image open" error: Load image before saving ROIs
// - "Not initialized" warning: Press "i" to initialize first

// Tips
// - Save multiple ROIs per image with repeated Alt+A
// - Export ROI set via ROI Manager (More > Save...)
// - Works with all image types (8/16/32-bit, RGB)


var outputDir = "";

// Initialize function with toolbar button
macro "ROI Saver Action Tool - C000 T0708I T0f08n T0f08i T0708t" {
    initializeROISaver();
}

// Initialize with keyboard shortcut
macro "Initialize ROI Saver [i]" {
    initializeROISaver();
}

// Save ROI with Alt+A keyboard shortcut
macro "Save ROI [a]" {
    saveCurrentROI();
}

// Core function to initialize the ROI Saver
function initializeROISaver() {
    // Get the output directory from user
    outputDir = getDirectory("Choose Output Directory");
    if (outputDir == "") {
        exit("No output directory selected");
    }
    run("Enhance Contrast", "saturated=0.35");
    // Display a confirmation message
    print("\\Clear");
    print("ROI Saver Initialized!");
    print("Output directory: " + outputDir);
    print("Press Alt+A to save ROIs as cell_N.tif");
}

// Core function to save the current ROI
function saveCurrentROI() {
    // Check if output dir is set
    if (outputDir == "") {
        showMessage("Please initialize the ROI Saver first!");
        return;
    }
    
    // Check if image is open
    if (nImages == 0) {
        showMessage("No image open!");
        return;
    }
    
    // Check if ROI is selected
    if (selectionType() == -1) {
        showMessage("No ROI selected!");
        return;
    }
    
    // Get next number for filename
    nextNumber = getNextFileNumber(outputDir);
    run("Add to Manager");
    // Get current selection and create a new image from it
    run("Duplicate...", "title=temp_roi");
    
        
    // Save the new image
    filename = "cell_" + toString(nextNumber) + ".tif";
    fullPath = outputDir + filename;
    saveAs("Tiff", fullPath);
    
    // Close the temporary image
    close();
    
    // Notify the user
    print("Saved ROI as: " + filename);
}

function getNextFileNumber(dir) {
    // Get list of files
    fileList = getFileList(dir);
    
    // Count total tif files in the directory
    tifCount = 0;
    for (i = 0; i < fileList.length; i++) {
        if (endsWith(fileList[i], ".tif")) {
            tifCount++;
        }
    }
    
    // Return count + 1 for the next number
    return tifCount + 1;
}