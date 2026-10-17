"""
order_total.py — educational debugging sample.

A tiny order-total calculator. The version below is the FIXED one.
See NOTES.md for the original bug, why it happened, and how it was fixed.

Run:  python3 order_total.py
"""

# FIX: use None as the default and create a fresh list inside the function.
# The buggy version used `items=[]` as a default argument, which made every
# call share ONE list object — totals leaked between orders.
def add_item(price, items=None):
    if items is None:
        items = []
    items.append(price)
    return items


def order_total(items):
    """Return the total of a list of prices, rounded to 2 decimals."""
    return round(sum(items), 2)


if __name__ == "__main__":
    # Order 1
    cart = add_item(19.99)
    cart = add_item(5.50, cart)
    print("Order 1 total:", order_total(cart))  # expected: 25.49

    # Order 2 must start empty — with the bug it would wrongly include
    # Order 1's items and print 60.48 instead of 34.99.
    cart2 = add_item(34.99)
    print("Order 2 total:", order_total(cart2))  # expected: 34.99
