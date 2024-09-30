import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PreferenceUploadFormComponent } from './preference-upload-form.component';
import { CommonModule } from '@angular/common';
import { ReactiveFormsModule } from '@angular/forms';
import { MatButtonModule } from '@angular/material/button';
import { MatFormFieldModule } from '@angular/material/form-field';
import { MatInputModule } from '@angular/material/input';
import { InventoryTableComponent } from '../../../../components/inventory-table/inventory-table.component';

describe('PreferenceUploadFormComponent', () => {
  let component: PreferenceUploadFormComponent;
  let fixture: ComponentFixture<PreferenceUploadFormComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [
        CommonModule,
        ReactiveFormsModule,
        MatButtonModule,
        MatFormFieldModule,
        MatInputModule,
        InventoryTableComponent,
        PreferenceUploadFormComponent,
      ],
    }).compileComponents();

    fixture = TestBed.createComponent(PreferenceUploadFormComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
