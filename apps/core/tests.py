from django.test import TestCase
from core.models import Element

# Create your tests here.
class ElementTestCase(TestCase):
    def setUp(self):
        Element.objects.create(name='Test Name', description='Test Description')
        Element.objects.create(name='Test Name2', description='Test Description2')
    
    def test_element_creation(self):
        element = Element.objects.get(name='Test Name')
        self.assertEqual(element.name, 'Test Name')
        self.assertEqual(element.description, 'Test Description')
    
    def test_element_creation2(self):
        element = Element.objects.get(name='Test Name2')
        self.assertEqual(element.name, 'Test Name2')
        self.assertEqual(element.description, 'Test Description2')
    
    def test_element_list(self):
        elements = Element.objects.all()
        self.assertEqual(len(elements), 2)
    
    def test_element_list2(self):  
        elements = Element.objects.all()
        self.assertEqual(elements[0].name, 'Test Name')
        self.assertEqual(elements[0].description, 'Test Description')
        self.assertEqual(elements[1].name, 'Test Name2')
        self.assertEqual(elements[1].description, 'Test Description2')
    
    def test_element_change(self):
        element = Element.objects.get(name='Test Name')
        element.name = 'Test Name Changed'
        element.description = 'Test Description Changed'
        element.save()
        element = Element.objects.get(name='Test Name Changed')
        self.assertEqual(element.name, 'Test Name Changed')
        self.assertEqual(element.description, 'Test Description Changed')
