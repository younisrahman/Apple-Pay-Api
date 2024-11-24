# **rn-apple-pay-api**

#### A React Native package that simplifies integrating Apple Pay functionality with API support. This library is compatible with both old and new versions of React Native, supporting the latest architecture.

---

## **Features**

- Easily integrate Apple Pay in your React Native apps.
- Compatible with both iOS 12+ and the latest React Native versions.
- Supports API calls for payment processing.
- Designed for flexibility and future-proofing.

---

# Installation

### 1. Install the Package

```bash
   npm install rn-apple-pay-api
```

### 2. Install iOS Dependencies

#### Navigate to your `ios` directory and run:

```bash
    cd ios
    pod install
```

Note: Make sure CocoaPods is installed and up to date. If you encounter issues, try updating pods with:

```bash
    pod repo update
```

### 3. Add the Apple Pay Merchant Identifier to Info.plist

In your iOS project, open the Info.plist file and add the following key:

```xml
<key>ApplePayMerchantIdentifier</key>
<string>your merchant id</string>
```

### This ensures that your app is configured to use the correct Apple Pay merchant identifier. For more details on setting up the Apple Pay Merchant ID, refer to [Apple's official guide](https://developer.apple.com/documentation/apple_pay_on_the_web/configuring_your_environment).

---

###Usage

#### Import and Use the Module 　

```javascript
import { getApplePayApi } from "rn-apple-pay-api";

// Example usage
const paymentDetails = {
  amount: 150.55, // The payment amount
  charge: 10.2, // Additional charges, e.g., service fees
  total: amount + charge, // Total amount (amount + charge)
  countryCode: "US", // Country code for the transaction
  currencyCode: "USD", // Currency code for the payment
  title: "Payment Title", // Title of the payment
  description: "This is a test payment", // Description of the payment
  cardTypes: ["Debit", "3DS"], // Accepted card types (TAppleCardTypeEnum[])
  authToken: "api token", // Bearer token for API authentication
  apiUrl: "https://test-api-younis-rahmans-projects.vercel.app/apple-pay", // API URL (test API provided)
  noApi: false, // If true, returns the Apple Pay token for manual handling
  isReject: false, // If true, rejects the request (useful for testing purposes)
  isSimulator: true, // Set to true when testing on a simulator
  data: { data: "data" }, // Additional data (optional, as required)
};

async function handlePayment() {
  try {
    const result = await getApplePayApi(paymentDetails);
    console.log("Payment Success:", result);
  } catch (error) {
    console.error("Payment Failed:", error);
  }
}
```

### Key Functions Used:

##### `isMakePayment()` Checks if Apple Pay is available on the current device and returns a boolean.

##### `getApplePayApi(paymentDetails)` Processes Apple Pay transactions and sends the payment token to your API.

---

### API Reference

### `openApplePay(paymentDetails)`

| **Property**   | **Type**               | **Required** | **Description**                                                                                                          |
| -------------- | ---------------------- | ------------ | ------------------------------------------------------------------------------------------------------------------------ |
| `amount`       | `number`               | Yes          | The payment amount.                                                                                                      |
| `charge`       | `number`               | Yes          | Any additional charges (e.g., taxes, fees).                                                                              |
| `total`        | `number`               | Yes          | The total payment amount (`amount + charge`).                                                                            |
| `countryCode`  | `string`               | Yes          | The country code for the transaction (e.g., `"US"`).                                                                     |
| `currencyCode` | `string`               | Yes          | The currency code for the transaction (e.g., `"USD"`).                                                                   |
| `title`        | `string`               | Yes          | The title for the payment request.                                                                                       |
| `description`  | `string`               | Yes          | A brief description of the payment purpose.                                                                              |
| `cardTypes`    | `TAppleCardTypeEnum[]` | Yes          | The list of allowed card types (e.g., `['Debit', '3DS']`).                                                               |
| `authToken`    | `string`               | Yes          | Bearer token for backend API authentication.                                                                             |
| `apiUrl`       | `string`               | Yes          | The URL of the API endpoint handling the payment request.                                                                |
| `noApi`        | `boolean`              | No           | If `true`, bypasses API calls and returns the Apple Pay token directly, returns the Apple Pay token for manual handling. |
| `isReject`     | `boolean`              | No           | If `true`, simulates a rejected payment request (for testing purposes).                                                  |
| `isSimulator`  | `boolean`              | No           | Set to `true` if testing on an iOS simulator.                                                                            |
| `data`         | `object`               | No           | Any additional data to pass to the API.                                                                                  |

---

## Table of Contents

1. [Overview](#overview)  
   1.1 [Purpose of the `paymentDetails` object](#purpose-of-the-paymentdetails-object)  
   1.2 [Context of use](#context-of-use)

2. [Properties](#properties)  
   2.1 [amount](#amount)  
   2.2 [charge](#charge)  
   2.3 [total](#total)  
   2.4 [countryCode](#countrycode)  
   2.5 [currencyCode](#currencycode)  
   2.6 [title](#title)  
   2.7 [description](#description)  
   2.8 [cardTypes](#cardtypes)  
   2.9 [authToken](#authtoken)  
   2.10 [apiUrl](#apiurl)  
   2.11 [noApi](#noapi)  
   2.12 [isReject](#isreject)  
   2.13 [isSimulator](#issimulator)  
   2.14 [data](#data)

3. [Usage Example](#usage-example)

4. [Testing Guidelines](#testing-guidelines)

5. [FAQs](#faqs)

6. [References](#references)

---

## 1. Overview

### 1.1 Purpose of the `paymentDetails` object

The `paymentDetails` object provides a structured representation of all parameters required to initiate an Apple Pay transaction.

### 1.2 Context of use

The `paymentDetails` object is used to configure and handle Apple Pay payment requests in your application.

---

## 2. Properties

### 2.1 `amount`

- **Definition**: The payment amount.
- **Data Type**: `number`

### 2.2 `charge`

- **Definition**: Additional charges, such as service fees.
- **Data Type**: `number`

### 2.3 `total`

- **Definition**: The total amount, calculated as `amount + charge`.
- **Data Type**: `number`

### 2.4 `countryCode`

- **Definition**: Country code for the transaction.
- **Example**: `'US'`
- **Data Type**: `string`

### 2.5 `currencyCode`

- **Definition**: Currency code for the payment.
- **Example**: `'USD'`
- **Data Type**: `string`

### 2.6 `title`

- **Definition**: Title of the payment.
- **Example**: `"Payment Title"`
- **Data Type**: `string`

### 2.7 `description`

- **Definition**: Description of the payment.
- **Example**: `"This is a test payment"`
- **Data Type**: `string`

### 2.8 `cardTypes`

- **Definition**: Accepted card types.
- **Example**: `['Debit', '3DS']`
- **Data Type**: `TAppleCardTypeEnum[]`

### 2.9 `authToken`

- **Definition**: Bearer token used for API authentication.
- **Example**: `"api token"`
- **Data Type**: `string`

### 2.10 `apiUrl`

- **Definition**: The API endpoint used for the payment request.
- **Example**: `"https://test-api-younis-rahmans-projects.vercel.app/apple-pay"`
- **Data Type**: `string`

### 2.11 `noApi`

- **Definition**: Determines whether to bypass the API and return the Apple Pay token for manual use.
- **Example**: `false`
- **Data Type**: `boolean`

### 2.12 `isReject`

- **Definition**: If true, the request will be rejected (useful for testing).
- **Example**: `false`
- **Data Type**: `boolean`

### 2.13 `isSimulator`

- **Definition**: Indicates if the payment is being tested on a simulator.
- **Example**: `true`
- **Data Type**: `boolean`

### 2.14 `data`

- **Definition**: Additional data that can be passed as required.
- **Example**: `{ data: "data" }`
- **Data Type**: `object`

---

## 3. Usage Example

```javascript
import React, { useState } from 'react';
import {
  StyleSheet,
  Text,
  View,
  TouchableOpacity
} from 'react-native';

import { TAppleCardTypeEnum, getApplePayApi, isMakePayment } from 'rn-apple-pay-api';

function App(): React.JSX.Element {
  const [isApplePayActive, setIsApplePayActive] = useState<boolean | null | undefined>();


  const canMakePayment = async () => {
    const canMakeApplePayment = await isMakePayment();
    setIsApplePayActive(canMakeApplePayment);
    console.log('=============canMakeApplePayment=======================');
    console.log(canMakeApplePayment);
    console.log('====================================');
  };



  const makePayment = async () => {

    const amount = 150.55;
    const charge = 10.20;
    const total = amount + charge;
    const countryCode = 'US';
    const currencyCode = "USD";
    const title = "Payment Title";
    const description = 'This is is test payment';
    const cardTypes: TAppleCardTypeEnum[] = ['Debit', '3DS'];
    const authToken = 'api token ';
    const apiUrl = "https://test-api-younis-rahmans-projects.vercel.app/apple-pay";
    const noApi = false;
    const isReject = false;
    const isSimulator = true;
    const data = { data: "data" };

    try {
      getApplePayApi(
        {
          amount,
          charge,
          total,
          countryCode,
          currencyCode,
          description,
          title,
          cardTypes,
          authToken,
          apiUrl,
          noApi,
          isReject,
          isSimulator,
          data,
        }
      )
        .then(token => {
          if (token) {
            console.log('====Api success================================');
            console.log(token);
            console.log('====================================');
          }
        })
        .catch(error => {
          console.log('===Api failed=================================');
          console.log(error);
          console.log('====================================');
        });
    } catch (error) {
      console.log('==Apple error==================================');
      console.log(error);
      console.log('====================================');
    }
  };

  return (
    <View style={styles.container}>

      <View>
        <Text>
          This is a Apple pay test
        </Text>
        <Text>
          Is a Apple pay available : {isApplePayActive ? 'Available' : 'Not Available'}
        </Text>
      </View>


      <TouchableOpacity
        onPress={() => canMakePayment()}
        style={styles.checkApplePay}
      >
        <Text style={styles.checkText} >Check Apple Pay Availability</Text>
      </TouchableOpacity>


      <TouchableOpacity
        onPress={() => makePayment()}
        style={styles.button}
      >
        <Text style={styles.text} >Apple Pay</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    justifyContent: 'center',
    alignItems: 'center',
    height: '100%'
  },
  checkApplePay: {
    height: 50,
    width: '80%',
    borderColor: 'black',
    borderWidth: 2,
    borderRadius: 10,
    marginTop: 30,
    justifyContent: 'center',
    alignItems: 'center',
  },
  button: {
    height: 50,
    width: '80%',
    backgroundColor: 'black',
    borderRadius: 10,
    marginTop: 30,
    justifyContent: 'center',
    alignItems: 'center',
  },
  text: {
    fontWeight: '600',
    color: 'white',
    fontSize: 16
  },
  checkText: {
    fontWeight: '600',
    color: 'black',
    fontSize: 16
  }
});

export default App;

```

---

## 4. Testing Guidelines

To ensure a seamless integration and proper functionality, follow these testing guidelines:

### Testing on Simulators

- Set the **`isSimulator`** property to `true` when running the payment integration on an iOS simulator.
- Example:
  ```javascript
  const paymentDetails = {
    isSimulator: true,
    // other properties
  };
  ```

````
### Bypassing API Calls
For custom workflows or manual handling of Apple Pay tokens, set `noApi` to `true` to bypass API calls.
Example:

```javascript
const paymentDetails = {
  noApi: true,
  // other properties
};
````

### 5. FAQs

1. **What happens if `noApi` is set to true?**  
   If `noApi` is set to true, the API call is bypassed, and the function directly retrieves and returns the Apple Pay token for custom processing.

2. **Is it safe to use `isReject` in production?**  
   No, the `isReject` property is for testing purposes only. It should not be used in production as it simulates failed payment scenarios.

3. **What are the valid values for `cardTypes`?**  
   Valid values include:

   - `['Debit']`
   - `['3DS']`
   - `['Debit', '3DS']`

   These represent accepted card types for Apple Pay transactions.

4. **Can `isSimulator` be used on a real device?**  
   No, `isSimulator` is specifically for iOS simulators. For real devices, ensure this property is set to false.

5. **How do I handle errors during API calls?**  
   Ensure proper error handling is implemented in your API integration to catch and display errors gracefully. You can log the response for debugging purposes.

### 6. References

Here are some helpful resources for understanding and implementing Apple Pay integration:

- [Apple Pay Official Documentation](https://developer.apple.com/apple-pay/)
- [React Native Official Documentation](https://reactnative.dev/docs/getting-started)
- [MDN Documentation on JavaScript Object Handling](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide/Working_with_Objects)

---

### License

This package is licensed under the `MIT License`.

---

### Contributing

Contributions are welcome! If you have suggestions or find `bugs`, please create an `issue or submit` a pull request on `GitHub`.
