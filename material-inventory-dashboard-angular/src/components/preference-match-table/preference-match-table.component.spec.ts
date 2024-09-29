import { ComponentFixture, TestBed } from '@angular/core/testing';

import { PreferenceMatchTableComponent } from './preference-match-table.component';

describe('PreferenceMatchTableComponent', () => {
  let component: PreferenceMatchTableComponent;
  let fixture: ComponentFixture<PreferenceMatchTableComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      imports: [PreferenceMatchTableComponent]
    })
    .compileComponents();

    fixture = TestBed.createComponent(PreferenceMatchTableComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
