___TERMS_OF_SERVICE___

By creating or modifying this file you agree to Google Tag Manager's Community
Template Gallery Developer Terms of Service available at
https://developers.google.com/tag-manager/gallery-tos (or such other URL as
Google may provide), as modified from time to time.


___INFO___

{
  "type": "MACRO",
  "id": "cvt_temp_public_id",
  "version": 1,
  "securityGroups": [],
  "displayName": "GA4 Session ID Extractor from Cookie",
  "categories": ["ANALYTICS", "ATTRIBUTION"],
  "description": "Extracts the GA4 session ID from the _ga_MEASUREMENTID cookie (e.g. _ga_G-XXXXXXXX). Supports GA4 Measurement ID or custom cookie value. Returns the session ID portion for use in server-side tagging.",
  "containerContexts": [
    "SERVER"
  ]
}


___TEMPLATE_PARAMETERS___

[
  {
    "type": "TEXT",
    "name": "measurementId",
    "displayName": "GA4 Measurement ID",
    "simpleValueType": true,
    "valueHint": "G-12345678",
    "visibility": "CUSTOM",
    "customVisibility": "data.useOwnVariable !\u003d\u003d true",
    "help": "The GA4 Measurement ID (e.g. G-12345678). Used to build the cookie name _ga_XXXX."
  },
  {
    "type": "CHECKBOX",
    "name": "useOwnVariable",
    "displayName": "Or use your own variable",
    "checkboxText": "Provide your own variable",
    "help": "Provide a variable that contains the value of the _ga_MEASUREMENTID cookie. This is useful in server-side requests where cookies may not be available in the request, such as a HTTP request directly from your  backend system"
  },
  {
    "type": "TEXT",
    "name": "cookieValue",
    "displayName": "Cookie Value Variable",
    "valueHint": "{{cookievalue - _ga_12AB34CZ",
    "simpleValueType": true,
    "allowVariableReference": true,
    "visibility": "CUSTOM",
    "customVisibility": "data.useOwnVariable \u003d\u003d\u003d true",
    "enablingConditions": [
      {
        "paramName": "useOwnVariable",
        "paramValue": true,
        "type": "EQUALS"
      }
    ],
    "help": "Insert a variable that contains the full _ga_MEASUREMENTID cookie value (e.g. GS2.1.s1747132561$o1$g0$t1747132655$j0$l0$h0)"
  },
  {
    "type": "CHECKBOX",
    "name": "debugMode",
    "displayName": "Enable Debug Output",
    "checkboxText": "Log details to console for debugging purposes"
  }
]


___SANDBOXED_JS_FOR_SERVER___

const makeString = require('makeString');
const getCookieValues = require('getCookieValues');
const log = require('logToConsole');

// Input fields
const useOwnVariable = data.useOwnVariable === true;
const measurementId = makeString(data.measurementId || '');
const cookieValueInput = makeString(data.cookieValue || '');
const debug = data.debugMode === true;

// Final cookie value
let cookieValue = '';

// Step 1: If user provided their own variable, use it
if (useOwnVariable && cookieValueInput) {
  cookieValue = cookieValueInput;
  if (debug) log('Using cookie value from user-defined variable:', cookieValue);
}

// Step 2: Else, build the cookie name from measurement ID and read it
else if (!useOwnVariable && measurementId && measurementId.indexOf('G-') === 0) {
  const suffix = measurementId.substring(2); // Strip "G-"
  const cookieName = '_ga_' + suffix;
  const cookies = getCookieValues(cookieName);
  if (cookies && cookies.length > 0) {
    cookieValue = cookies[0];
    if (debug) log('Using cookie from browser for name ' + cookieName + ':', cookieValue);
  } else {
    if (debug) log('No cookie found for name ' + cookieName);
  }
} else {
  if (debug) log('No valid cookie source provided.');
}

// Step 3: Extract session ID (between .s and first $)
if (cookieValue && cookieValue.indexOf('.s') !== -1) {
  const sessionPart = cookieValue.split('.s')[1];
  if (sessionPart) {
    const sessionId = sessionPart.split('$')[0];
    if (debug) log('Extracted session ID:', sessionId);
    return sessionId;
  } else {
    if (debug) log('Could not split .s section of cookie.');
  }
} else {
  if (debug) log('Cookie value does not contain expected ".s" format.');
}


___SERVER_PERMISSIONS___

[
  {
    "instance": {
      "key": {
        "publicId": "get_cookies",
        "versionId": "1"
      },
      "param": [
        {
          "key": "cookieAccess",
          "value": {
            "type": 1,
            "string": "any"
          }
        }
      ]
    },
    "clientAnnotations": {
      "isEditedByUser": true
    },
    "isRequired": true
  },
  {
    "instance": {
      "key": {
        "publicId": "logging",
        "versionId": "1"
      },
      "param": [
        {
          "key": "environments",
          "value": {
            "type": 1,
            "string": "debug"
          }
        }
      ]
    },
    "isRequired": true
  }
]


___TESTS___

scenarios: []
setup: ''


___NOTES___

Created on 26-5-2025, 13:05:40


