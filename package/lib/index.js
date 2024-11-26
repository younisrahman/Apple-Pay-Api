var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
//@ts-ignore
import { NativeModules, Platform } from 'react-native';
const LINKING_ERROR = `The library 'apple-pay' doesn't seem to be linked. Make sure: \n\n` +
    Platform.select({ ios: "- You have run 'pod install'\n", default: '' }) +
    '- You rebuilt the app after installing the package\n' +
    '\n';
const ApplePayApi = NativeModules.ApplePayApi
    ? NativeModules.ApplePayApi
    : new Proxy({}, {
        get() {
            throw new Error(LINKING_ERROR);
        },
    });
export function getApplePayApi(data) {
    return __awaiter(this, void 0, void 0, function* () {
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
        return yield ApplePayApi.getApplePayApi(amount, charge, total, countryCode, currencyCode, description, title, cardTypes, authToken, apiUrl, noApi, isReject, isSimulator, extraData);
    });
}
export function canMakePayments() {
    return ApplePayApi.canMakePayments();
}
export function canSetupCards() {
    return ApplePayApi.canSetupCards();
}
export function navigateToSetup() {
    return ApplePayApi.navigateToSetup();
}
export function isMakePayment() {
    return __awaiter(this, void 0, void 0, function* () {
        try {
            const result = yield canMakePayments();
            return result;
        }
        catch (error) {
            console.error('Error checking payment capability:', error);
            return false;
        }
    });
}
//# sourceMappingURL=index.js.map