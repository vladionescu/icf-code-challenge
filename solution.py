#!/usr/bin/env python2
#amount = 46
#amount = 41
#amount = 20
#amount = 73
#amount = 91
#amount = 78
#amount = 1200000
amounts = [46, 41, 20, 73, 91, 78, 1200000]
denoms = [2, 10, 20, 5, 2, 1]

def findMinCoins(amount):
    # put your algorithm here
    global denoms
    denoms = sorted(denoms)
#    print denoms

    leftovers = amount
    makeup = []

    for denom in denoms[::-1]:
        nr_fit_inside = leftovers / denom
#        print str(nr_fit_inside) + " || " + str(denom)

        if nr_fit_inside:
            for i in xrange(nr_fit_inside):
                makeup.append(denom)

            leftovers = leftovers - (denom * nr_fit_inside)

#            print leftovers

            if not leftovers:
#                print "we done here."
                break

#            print "again!"
  
#    print makeup
    coins = len(makeup)
    return coins;

for amount in amounts:
    print "{amount} can be paid with {coins} coins".format(amount=amount, coins=findMinCoins(amount))
