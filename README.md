# AstraZeneca-openFDA-Case-Study

## Overview

The files in this repository were developed as part of an interview with AstraZeneca Oncology Machine Learning & AI. The general ask was to explore the drug adverse event reporting data available via the FDA's openFDA Adverse Event Reporting System (FAERS) API at [https://open.fda.gov/drug/event/](https://open.fda.gov/drug/event/).

For ease of use I've created several rmarkdown files for the case study and have deployed them on a github.io site for viewing. The site can be accessed here **[https://bmanry13.github.io/AstraZeneca-openFDA-Case-Study/index.html](https://bmanry13.github.io/AstraZeneca-openFDA-Case-Study/index.html)**. The notebooks contain API calls for accessing the data directly from FDA so can be run locally with a cloned repository.

The site pages include:

* **[Documentation Review](https://bmanry13.github.io/AstraZeneca-openFDA-Case-Study/index.html):** A documentation review/overview of the openFDA FAERS data and API. This section is a qualitative look at how the event data is collected, what the reports contain, and some general observations that I had related to the limitations or potential biases to consider when using the data.

* **[Initial Data Exploration](https://bmanry13.github.io/AstraZeneca-openFDA-Case-Study/Initial-Data-Exploration.html):** In this section I wanted to get a feel for how the various API syntax options operate, how/what data is returned by the API, and explore distibutions of values present in the data for select fields like reporter type, country, and event type.

* **[Feasability Testing](https://bmanry13.github.io/AstraZeneca-openFDA-Case-Study/Feasability-Testing.html):** In this section I explored the feasability of interacting with the openFDA data more advanced ways (e.g., downloading reaction reports beyond the maximum limit of 100)

## R Packages Used in Analysis
- ggplot2: [https://github.com/hadley/ggplot2](https://github.com/hadley/ggplot2)
- jsonlite: [https://github.com/jeroen/jsonlite](https://github.com/jeroen/jsonlite)
- dplyr: [https://github.com/tidyverse/dplyr](https://github.com/tidyverse/dplyr)
- tidyr: [https://github.com/tidyverse/tidyr](https://github.com/tidyverse/tidyr)
- rmarkdown: [https://github.com/rstudio/rmarkdown](https://github.com/rstudio/rmarkdown)
- knitr: [https://github.com/yihui/knitr](https://github.com/yihui/knitr)
- kableExtra: [https://github.com/haozhu233/kableExtra](https://github.com/haozhu233/kableExtra)