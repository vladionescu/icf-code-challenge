## What is this?

One morning, my friend @icflournoy sent me the challenge below. I was looking
for something to occupy myself with while coffee brewed so I took him up on it.

I was younger then. More naive, too.

## Initial Challenge

```
var amount = 46;
var denoms = [2, 10, 20, 5, 2, 1];

function findMinCoins(amount) {
      // put your algorithm here
        return coins;
};

console.log(findMinCoins(amount))
```

You have an amount of money, and denominations as indicated in the
denominations array. What is the minimum number of bills to total the amount.

Output (doesn't have to be exact)
```
41 can be paid with 3 bills
46 can be paid with 4 bills
20 can be paid with 1 bill
73 can be paid with 6 bills
91 can be paid with 6 bills
78 can be paid with 7 bills
1200000 can be paid with 60000 bills
```

## What happened?

He solved it in nodeJS, so naturally I did it in Python.

Happy with my solution but looking to ~procrastinate more~ work harder I
followed up with a pure C solution. Back at RIT we used to hack away at C
programs together; I guess I got nostalgic.

Then this happened:

![challengeaccepted.jpg](https://user-images.githubusercontent.com/5445781/31804034-ccdea582-b50b-11e7-82fc-4f11ede68bca.png)

## Results

| Language  | Line Numbers  | Dev Time  | Runtime (user) |
| --------- |:-------------:| ---------:| --------------:|
| Python    | 44            | 30 mins   | 0m0.027s       |
| C         | 95            | 58 mins   | 0m0.001s       |
| nasm x86  | 274 + 15 (Makefile) | 10 hrs | 0m0.000s    |

There's a story in here, somewhere, about optimization and diminishing returns.

### Notes

Development was done on macOS Sierra 10.12.6, so the binaries and assembly are
for Mach-O. If you want to `make` on a different platform, the C code should
work out of the box, but the assembly might take some tweaking (plus, Makefile
should be modified to account for the weird `ld` Apple bundles).

###### But really this code is useless so just take my word for it that it works.
