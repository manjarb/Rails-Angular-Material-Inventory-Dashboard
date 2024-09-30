import { ComponentFixture, TestBed } from '@angular/core/testing';
import { provideHttpClientTesting } from '@angular/common/http/testing';
import { InventoryInfoComponent } from './inventory-info.component';
import { CommonModule } from '@angular/common';
import { InventoryTableComponent } from '../../../components/inventory-table/inventory-table.component';
import { InventoryService } from '../services/inventory.service';
import { provideHttpClient } from '@angular/common/http';

describe('InventoryInfoComponent', () => {
  let component: InventoryInfoComponent;
  let fixture: ComponentFixture<InventoryInfoComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [InventoryTableComponent, CommonModule, InventoryInfoComponent],
      providers: [
        InventoryService,
        provideHttpClient(),
        provideHttpClientTesting(),
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(InventoryInfoComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
