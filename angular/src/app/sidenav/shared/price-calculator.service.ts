import { Injectable } from '@angular/core';

import { ExtraView, OrderView } from '../../shared/viewModels/interfaces';
import {reduce, chain} from 'lodash';

@Injectable()
export class PriceCalculatorService {

  getPrice(order: OrderView): number {
    const extrasPrice: number = chain(order.extras)
     .filter((extra: ExtraView) => extra.selected)
     .reduce((total: number, extra: ExtraView): number => total + extra.price, 0)
     .value();

    return (order.price + extrasPrice) * order.amount;
  }

  getTotalPrice(orders: OrderView[]): number {
    return reduce(orders, (sum: number, order: OrderView): number => sum + this.getPrice(order), 0);
  }

}
