# jhipster2ionic
Script for migrating JHpister frontend into Ionic framework

## Usage
First create JHipster monolith project, then create ionic project:

```docker run -it -v /c//Users/markus/Projects/jhipster:/home/jhipster/app jhipster/jhipster /bin/bash```

```ionic start mobileApp blank```

Then start migration:

```./converter.sh [jhipster project path] [ionic project path]```

When script finishes, do the following steps:

**src\app\main.ts:** remove:
```
  if (module['hot']) {
      module['hot'].accept();
  }
```
For all modules in **src\app\FOLDER\FOLDER.module.ts:** add:
```
  import {IonicModule} from "ionic-angular";
  imports: [
      IonicModule
  ],
  ```
For all components in **src\app\FOLDER\FOLDER.component.ts:** remove:
```
styleUrls: [
    'FOLDER.css'
]
```

