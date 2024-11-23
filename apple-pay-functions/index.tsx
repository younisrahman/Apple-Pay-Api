import { NativeModules, Platform } from 'react-native';

const LINKING_ERROR =
  `The library 'apple-pay' doesn't seem to be linked. Make sure: \n\n` +
  Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
  '- You rebuilt the app after installing the package\n' +
  '\n';

const ApplePayApi = NativeModules.ApplePayApi
  ? NativeModules.ApplePayApi
  : new Proxy(
    {},
    {
      get() {
        throw new Error(LINKING_ERROR);
      },
    },
  );

interface ApplePayResponse {
  token: string;
  success: boolean;
}
export type TAppleCardTypeEnum = '3DS' | 'Debit' | 'Credit';

export interface IApplePay {
  amount: number;
  charge: number;
  total: number;
  countryCode: string;
  currencyCode: string;
  description: string;
  title: string;
  cardTypes: TAppleCardTypeEnum[];
  authToken?: string;
  apiUrl?: string;
  noApi?: boolean;
  isReject?: boolean;
  isSimulator?: boolean;
  data?: Record<string, any>;
}

export async function getApplePayApi(data: IApplePay): Promise<ApplePayResponse> {

  const amount = data.amount;
  const charge = data.charge;
  const total = data.total;
  const countryCode = data.countryCode;
  const currencyCode = data.currencyCode;
  const description = data.description;
  const title = data.title;
  const cardTypes = data.cardTypes;
  const authToken = data.authToken || undefined;
  const apiUrl = data.apiUrl || undefined;
  const noApi = data.noApi || false;
  const isReject = data.isReject || false;
  const isSimulator = data.isSimulator || false;
  const extraData = data.data || undefined;

  return await ApplePayApi.getApplePayApi(
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
    extraData
  );
}

export function canMakePayments(): Promise<boolean> {
  return ApplePayApi.canMakePayments();
}

export function canSetupCards(): Promise<boolean> {
  return ApplePayApi.canSetupCards();
}

export function navigateToSetup(): Promise<void> {
  return ApplePayApi.navigateToSetup();
}

export async function isMakePayment(): Promise<boolean> {
  try {
    const result = await canMakePayments();
    return result;
  } catch (error) {
    console.error('Error checking payment capability:', error);
    return false;
  }
}
