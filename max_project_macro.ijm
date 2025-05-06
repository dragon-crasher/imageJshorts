macro "Batch VSI to Max Projection" {
    inputDir = getDirectory("Choose Input Directory");
    outputDir = getDirectory("Choose Output Directory");
    File.makeDirectory(outputDir);
    
    list = getFileList(inputDir);
    for (i = 0; i < list.length; i++) {
        if (endsWith(list[i], ".vsi")) {
            processFile(inputDir, outputDir, list[i]);
        }
    }
    print("Processing complete!");
}

function processFile(inputDir, outputDir, filename) {
    // Open VSI file
    path = inputDir + filename;
    run("Bio-Formats Windowless Importer", "open=[" + path + "] color_mode=Composite view=Hyperstack");
    baseName = File.getNameWithoutExtension(filename);
    
    // Check stack depth
    if (nSlices > 1) {
        // Max projection for Z-stacks
        run("Z Project...", "projection=[Max Intensity]");
        saveAs("Tiff", outputDir + baseName + "_Max.tif");
        close("*"); // Close max projection
    } else {
        // Single slice - close without saving
        close();
    }
    //close(); // Close original image
}
