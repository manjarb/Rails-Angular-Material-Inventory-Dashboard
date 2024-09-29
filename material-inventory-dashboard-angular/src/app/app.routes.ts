import { Routes } from '@angular/router';

export const routes: Routes = [
  { path: '', redirectTo: '/inventories', pathMatch: 'full' },
  {
    path: 'inventories',
    loadChildren: () =>
      import('../pages/inventory/inventory.module').then(
        (m) => m.InventoryModule
      ),
  },
  {
    path: 'preferences',
    loadChildren: () =>
      import('../pages/preference/preference.module').then(
        (m) => m.PreferenceModule
      ),
  },
];
