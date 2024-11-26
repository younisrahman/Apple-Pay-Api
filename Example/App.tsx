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




