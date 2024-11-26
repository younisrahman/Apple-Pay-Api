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
export declare function getApplePayApi(data: IApplePay): Promise<ApplePayResponse>;
export declare function canMakePayments(): Promise<boolean>;
export declare function canSetupCards(): Promise<boolean>;
export declare function navigateToSetup(): Promise<void>;
export declare function isMakePayment(): Promise<boolean>;
export {};
//# sourceMappingURL=index.d.ts.map