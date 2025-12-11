from docutils import nodes
from docutils.parsers.rst import Directive
import os

class DirectoryListingDirective(Directive):
    required_arguments = 1

    def run(self):
        env = self.state.document.settings.env
        docname = env.docname

        rel_dir_path = self.arguments[0]
        current_doc_path = env.doc2path(docname)
        current_doc_dir = os.path.dirname(current_doc_path)
        absolute_dir_path = os.path.normpath(os.path.join(current_doc_dir, rel_dir_path))

        print('aaaadir1:', current_doc_path)
        print('aaaadir2:', env.srcdir)
        if not os.path.isdir(absolute_dir_path):
            error = self.state_machine.reporter.error(
                 f"Directory '{absolute_dir_path}' not found.",
                nodes.literal_block(self.block_text, self.block_text),
            )
            return [error]

        # Container for the title and the list
        container = nodes.container()

        # Add a title to the container
        title_text = f"Directory listing for {os.path.join('/', os.path.relpath(absolute_dir_path, env.srcdir))}/"
        title_node = nodes.paragraph(text=title_text)
        title_node['classes'].append('custom-directory-listing-title')
        container += title_node

        # Add a horizontal rule after the title
        hr_node = nodes.raw('', '<hr>', format='html')
        container += hr_node

        list_node = nodes.bullet_list()


        # Add a list item for the parent directory
        parent_item_node = nodes.list_item()
        parent_ref_node = nodes.reference()
        # Construct the relative path to the parent directory
        parent_dir_path = os.path.join(rel_dir_path, '..')
        parent_ref_node['refuri'] = parent_dir_path
        parent_ref_node.append(nodes.Text('Parent Directory/'))
        parent_para_node = nodes.paragraph()
        parent_para_node += parent_ref_node
        parent_item_node += parent_para_node
        list_node += parent_item_node


        for filename in sorted(os.listdir(absolute_dir_path)):
            if filename == 'index.rst':
                continue
            item_node = nodes.list_item()
            file_rel_path = os.path.join(absolute_dir_path, filename)
            self.state_machine.reporter.info(f"Adding file '{file_rel_path}'")
            # Use the relative file path directly without assuming it's an HTML file
            ref_node = nodes.reference()
            ref_node['refuri'] = filename
            text = filename+'/' if os.path.isdir(file_rel_path) else filename

            ref_node.append(nodes.Text(text))

            para_node = nodes.paragraph()
            para_node += ref_node
            item_node += para_node
            list_node += item_node

        # Add the list to the container
        container += list_node

        return [container]


def setup(app):
    app.add_directive('dirlist', DirectoryListingDirective)
    return {
        'parallel_read_safe': True,
        'parallel_write_safe': True,
    }