# money-manager

The application was written on the Swift language using the MVP-C architecture with using router and view models. The application uses UserDefaults and CoreData framework for saving data locally.

The main task of the application is create a Bitcoin expense tracking app with two screens. The first screen shows the Bitcoin balance with options to replenish it and add transactions. Transactions are grouped by day and displayed with details like time, amount spent, and category. The second screen allows users to input transaction details and add them to the balance. Additionally, the app should display the Bitcoin exchange rate against the dollar, updating hourly.

The Bitcoin exchange rate we receive from the public [API](https://api.coindesk.com/v1/bpi/currentprice.json)

## First Screen

Top up balance, list of all transactions, bitcoin exhcange rate

![SimulatorScreenRecording-iPhoneXr-2024-04-17at08 47 38-ezgif com-optimize](https://github.com/Melmox/money-manager/assets/84095727/5ff818ca-58ef-44c8-9e60-0b488be35f89)

## Second Screen

Add transaction, select category of transaction

![SimulatorScreenRecording-iPhoneXr-2024-04-17at08 56 09-ezgif com-optimize](https://github.com/Melmox/money-manager/assets/84095727/19a2b01e-9c07-4194-99e9-52187e88e239)
