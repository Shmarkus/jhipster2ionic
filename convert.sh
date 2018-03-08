#!/usr/bin/env bash
JHIPSTER=$1
IONIC=$2
FRANKENPRJ='./frankenprj'

echo "Creating output projects in folder $FRANKENPRJ"
mkdir -p $FRANKENPRJ/src
echo "Moving typescript source files to output project"
mv $JHIPSTER/src/main/webapp/app $FRANKENPRJ/src/app
echo "Creating folder for assets"
mkdir -p $FRANKENPRJ/src/assets
echo "Moving images to assets"
mv $JHIPSTER/src/main/webapp/content/images $FRANKENPRJ/src/assets/images
mkdir -p $FRANKENPRJ/src/assets/icon
echo "Moving favicon to assets"
mv $JHIPSTER/src/main/webapp/favicon.ico $FRANKENPRJ/src/assets/icon/favicon.ico
echo "Moving package.json to output project"
mv $JHIPSTER/package.json $FRANKENPRJ/package.json
echo "Renaming app.main.ts to main.ts"
mv $FRANKENPRJ/src/app/app.main.ts $FRANKENPRJ/src/app/main.ts
echo "Creating folder for theme"
mkdir -p $FRANKENPRJ/src/theme
echo "Moving scss files to output project"
mv $IONIC/src/theme/variables.scss $FRANKENPRJ/src/theme/variables.scss
echo "Moving index.html files to output project"
mv $IONIC/src/index.html $FRANKENPRJ/src/index.html
echo "Moving manifest.json to output project"
mv $IONIC/src/manifest.json $FRANKENPRJ/src/manifest.json
echo "Moving service-worker.js to output project"
mv $IONIC/src/service-worker.js $FRANKENPRJ/src/service-worker.js
echo "Moving config.xml to output project"
mv $IONIC/config.xml $FRANKENPRJ/config.xml
echo "Moving ionic.config.json to output project"
mv $IONIC/ionic.config.json $FRANKENPRJ/ionic.config.json
echo "Moving tslint.json to output project"
mv $IONIC/tslint.json $FRANKENPRJ/tslint.json
echo "Moving tsconfig.json to output project"
mv $IONIC/tsconfig.json $FRANKENPRJ/tsconfig.json
echo "Moving resources to output project"
mv $IONIC/resources $FRANKENPRJ/resources

echo "Removing reference to unused vendor.css"
sed -i -E "s/import '..\/content\/css\/vendor.css';//" $FRANKENPRJ/src/app/vendor.ts
echo "Removing reference to unused manifest.webapp"
sed -i -E "s/require\('..\/manifest.webapp'\);//" $FRANKENPRJ/src/app/polyfills.ts
echo "Adding bootstrap import to theme variables.scss"
echo "@import 'https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css';\
" >> $FRANKENPRJ/src/theme/variables.scss
echo "@import 'https://maxcdn.bootstrapcdn.com/font-awesome/3.2.1/css/font-awesome.min.css';\
" >> $FRANKENPRJ/src/theme/variables.scss
echo "Adding Ionic imports, providers to app.module.ts"
echo -e "import {ErrorHandler} from '@angular/core';\n\
import {IonicApp, IonicErrorHandler, IonicModule} from 'ionic-angular';\n\
import {SplashScreen} from '@ionic-native/splash-screen';\n\
import {StatusBar} from '@ionic-native/status-bar';\n\
$(cat $FRANKENPRJ/src/app/app.module.ts)" > $FRANKENPRJ/src/app/app.module.ts
sed -i -E "s/\[ JhiMainComponent \]/\[IonicApp\]/" $FRANKENPRJ/src/app/app.module.ts
sed -i -E "s/imports\: \[/imports: \[\n\tIonicModule.forRoot\(JhiMainComponent\),/" $FRANKENPRJ/src/app/app.module.ts
sed -i -E "s/providers\: \[/providers: \[\n\tStatusBar,\n\tSplashScreen,\n\t\{provide: ErrorHandler, useClass: IonicErrorHandler\},/" $FRANKENPRJ/src/app/app.module.ts

echo "Setting configuration"
sed -i -E "s/process.env.VERSION/'1.0.0-SNAPSHOT'/" $FRANKENPRJ/src/app/app.constants.ts
sed -i -E "s/process.env.DEBUG_INFO_ENABLED/true/" $FRANKENPRJ/src/app/app.constants.ts
sed -i -E "s/process.env.SERVER_API_URL/'http:\/\/localhost:8080'/" $FRANKENPRJ/src/app/app.constants.ts
sed -i -E "s/process.env.BUILD_TIMESTAMP/''/" $FRANKENPRJ/src/app/app.constants.ts

echo "Fixing image path in stylesheets"
sed -i -E "s/content/assets/" $FRANKENPRJ/src/app/home/home.css
sed -i -E "s/content/assets/" $FRANKENPRJ/src/app/layouts/navbar/navbar.css

echo "Installing Ionic NPM dependencies..."
cd $FRANKENPRJ
npm i @ionic/app-scripts@3.1.8 --save-dev
npm i @angular/compiler-cli@5.0.3 @ionic-native/core@4.4.0 @ionic-native/splash-screen@4.4.0 @ionic-native/status-bar@4.4.0 @ionic-native/toast@4.3.0 @ionic/storage@2.1.3 ionic-angular@3.9.2 ionicons@3.0.0 --save

echo "Renaming css to scss"
for i in src/app/**/*.css; do mv $i ${i/.css/.scss}; done
for i in src/app/**/**/*.css; do mv $i ${i/.css/.scss}; done

echo "Done with the automatic part, now do manual steps!"
