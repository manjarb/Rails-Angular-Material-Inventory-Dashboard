import { ComponentFixture, TestBed } from '@angular/core/testing';

import { InventoryTableComponent } from './inventory-table.component';
import { MatTableModule } from '@angular/material/table';
import { MatPaginatorModule } from '@angular/material/paginator';
import { CommonModule } from '@angular/common';
import { MatButtonToggleModule } from '@angular/material/button-toggle';
import { InventoryService } from '../../pages/inventory/services/inventory.service';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { ComponentRef } from '@angular/core';

describe('InventoryTableComponent', () => {
  let component: InventoryTableComponent;
  let componentRef: ComponentRef<InventoryTableComponent>;
  let fixture: ComponentFixture<InventoryTableComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        MatTableModule,
        MatPaginatorModule,
        CommonModule,
        MatButtonToggleModule,
        InventoryTableComponent,
      ],
      providers: [
        InventoryService,
        provideHttpClient(),
        provideHttpClientTesting(),
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(InventoryTableComponent);
    component = fixture.componentInstance;
    componentRef = fixture.componentRef;
    componentRef.setInput('total', 10);
    componentRef.setInput('page', 10);
    componentRef.setInput('pageSize', 10);

    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
