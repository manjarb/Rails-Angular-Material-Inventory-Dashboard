import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PreferenceMatchTableComponent } from './preference-match-table.component';
import { MatPaginatorModule } from '@angular/material/paginator';
import { CommonModule } from '@angular/common';
import { MatTableModule } from '@angular/material/table';
import { InventoryService } from '../../pages/inventory/services/inventory.service';
import { provideHttpClient } from '@angular/common/http';
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { ComponentRef } from '@angular/core';

describe('PreferenceMatchTableComponent', () => {
  let component: PreferenceMatchTableComponent;
  let componentRef: ComponentRef<PreferenceMatchTableComponent>;
  let fixture: ComponentFixture<PreferenceMatchTableComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        MatTableModule,
        MatPaginatorModule,
        CommonModule,
        PreferenceMatchTableComponent,
      ],
      providers: [
        InventoryService,
        provideHttpClient(),
        provideHttpClientTesting(),
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(PreferenceMatchTableComponent);
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
