Create a branch and:

- Follow the naming convention for your session's directory (`YYYY-MM-DD Session Name`)
- Include a `README.md` for your session to introduce it + any slides that you use as `.pdf` (renders in GitHub unlike `.pptx`)
- Include code to play along as either:
    + `.ipynb` notebooks (to facilitate JupyterLab better than `.R` or `.py` ensuring you [clear all of the cell outputs](https://stackoverflow.com/questions/39924826/keyboard-shortcut-to-clear-cell-output-in-jupyter-notebook) before your session)
    + `.R` files if you are demoing RStudio / R Shiny
- Update any of the files (Python -> `environment.yml` or R -> `install.R`) in the `binder` directory with any new dependencies

When you are happy, submit a pull request:

- Check everything works in the `github-actions` pull request Binder link
- Merge it once approved by at least one of the previous hosts

Finally, after your session if you have used `.ipynb` notebooks then create another branch and:

- Include the cell outputs
- Submit a pull request and merge it once approved by at least one of the previous hosts

Note: If you are using `.ipynb` notebooks then the easiest way to create new content is by using [conda](https://conda.io/projects/conda/en/latest/index.html) to create an environment using `environment.yml` and then launch JupyterLab.

Note: If you encounter error showing : Git Clone "Filename too long" Error in Windows, you might want to use gitbash with below command:
*git clone "https://github.com/nhsbsa-data-analytics/coffee-and-coding.git" -c core.longpaths=true*
