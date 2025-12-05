# Contributing to Fox CC

Thank you for your interest in contributing to Fox CC! This document provides guidelines on how to contribute to this project.

## How to Contribute

### Submitting Documentation

If you want to contribute documentation or instructions (including PDF files):

1. **Fork the Repository**: Click the "Fork" button at the top right of the repository page.

2. **Clone Your Fork**:
   ```bash
   git clone https://github.com/YOUR-USERNAME/Fox-CC.git
   cd Fox-CC
   ```

3. **Create a New Branch**:
   ```bash
   git checkout -b add-documentation
   ```

4. **Add Your Files**:
   - For PDF documents, create a `docs/` folder if it doesn't exist
   - Place your PDF files in the `docs/` folder
   - Example: `docs/user-guide.pdf`, `docs/installation-guide.pdf`

5. **Commit Your Changes**:
   ```bash
   git add .
   git commit -m "Add documentation: [description of your document]"
   ```

6. **Push to Your Fork**:
   ```bash
   git push origin add-documentation
   ```

7. **Create a Pull Request**: Go to the original repository and click "New Pull Request".

### Uploading PDF Files

When uploading PDF documents:

1. **File Naming**: Use descriptive, lowercase names with hyphens (e.g., `installation-guide.pdf`, `user-manual.pdf`)

2. **File Size**: Keep PDF files under 10MB when possible. For larger files, consider:
   - Compressing the PDF
   - Hosting externally and linking in the README

3. **Location**: Place PDF files in the `docs/` directory:
   ```
   Fox-CC/
   ├── docs/
   │   ├── user-guide.pdf
   │   └── installation-instructions.pdf
   ├── cc.py
   ├── bin.py
   └── ...
   ```

4. **Reference in README**: After adding a PDF, update the README.md to include a link:
   ```markdown
   ## Documentation
   - [User Guide](docs/user-guide.pdf)
   - [Installation Instructions](docs/installation-instructions.pdf)
   ```

### Alternative: Using GitHub Issues

If you cannot create a pull request, you can also:

1. **Create an Issue**: Go to the Issues tab and click "New Issue"
2. **Attach Your PDF**: Drag and drop your PDF file into the issue description
3. **Describe Your Contribution**: Explain what the document contains and where it should be added

## Code Contributions

For code changes:

1. Follow the existing code style
2. Test your changes before submitting
3. Update documentation if needed

## Questions?

If you have questions about contributing, please open an issue with the label "question".
